using Serilog;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Timers;


namespace FileWatcher.Server.Modles
{
    internal sealed class FileChangedPolling : IDisposable
    {
        Timer _timer;
        string _path;
        bool _isExecuting = false;
        bool _incSubDir = false;
        Dictionary<string, FileItem> _items;
        public event EventHandler<FileSystemEventArgs> Changed;

        public FileChangedPolling(string path, bool incSub = false)
        {
            _path = path;
            _incSubDir = incSub;
            _items = GenData();
            _timer = new Timer(1000d);
            _timer.AutoReset = true;
            _timer.Start();

        }
        private Dictionary<string, FileItem> GenData()
        {
            if (!Directory.Exists(_path))
                throw new ArgumentException($"File change polling path'{_path}' not exist!");

            var files = new Dictionary<string, FileItem>();
            var tmp = Directory.EnumerateFiles(_path, "*.*", _incSubDir ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly);
            foreach (string t in tmp)
            {
                var fi = new FileInfo(t);
                if (fi.Exists)
                    files.Add(fi.FullName, new FileItem() { Size = fi.Length, LastWrite = fi.LastWriteTime });
            }
            return files;
        }

        private void _time_Elapsed(object sender, ElapsedEventArgs e)
        {
            if (_isExecuting) return;
            _isExecuting = true;
            var newItems = GenData();
            var chgs = newItems.Keys.ToList().Intersect(_items.Keys.ToList());
            Compare(chgs.ToArray(), _items, newItems);
            _items = newItems;
            _isExecuting = false;
        }
        private void Compare(string[] keys, Dictionary<string, FileItem> oldItems, Dictionary<string, FileItem> newItems)
        {
            foreach (string key in keys)
            {
                if (oldItems.ContainsKey(key) && newItems.ContainsKey(key))
                {
                    if (oldItems[key].Size != newItems[key].Size || oldItems[key].LastWrite != newItems[key].LastWrite)
                        Changed?.Invoke(this, new FileSystemEventArgs(WatcherChangeTypes.Changed, Path.GetDirectoryName(key), Path.GetFileName(key)));
                }
            }
        }
        public void Dispose()
        {
            if (_timer != null)
                _timer.Dispose();
        }
    }
    internal class FileItem
    {
        public double Size { get; set; }
        public DateTime LastWrite { get; set; }
    }
}
