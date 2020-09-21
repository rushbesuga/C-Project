using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Serilog;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Collections.Concurrent;
using System.Linq;
namespace FileWatcher.Server.Modles
{
    internal sealed class FileWatchExecutor
    {
        #region config
        public static bool LogFSWEvents = false;
        public static bool LogFileReadyEvents = false;
        static bool FSWUseRegex = false;
        static string FSWRegex = null;
        static IEnumerable<string> WatchKinds = null;
        #endregion
        #region private vars
        private List<string> _filteredFileTypes;
        private List<FileSystemWatcher> _fileSystemWatchers;
        private List<FileChangedPolling> _fileChangeds;
        #endregion
        #region Singletone
        public static readonly FileWatchExecutor instance = new FileWatchExecutor();

        static FileWatchExecutor() { }
        private FileWatchExecutor() { }
        public static FileWatchExecutor Instance
        {
            get
            {
                return instance;
            }
        }
        #endregion
        #region events
        public static event EventHandler<FileSystemEventArgs> OnFileReady;
        #endregion

        public void Watch(string[] sources, List<string> fileTypes, bool incSubDir = false)
        {
            Instance._filteredFileTypes = fileTypes;
            Instance._Watch(incSubDir, sources);

        }
        private void _Watch(bool incSubDir, string[] sources)
        {
            ReadAllSettings();
            if (!(sources.Length > 0))
            {
                Log.Warning("Cannot Proceed without FSW sources");
                return;
            }

            _fileSystemWatchers = new List<FileSystemWatcher>();
            _fileChangeds = new List<FileChangedPolling>();
            foreach (string source in sources)
                AddWatcher(source, incSubDir);

                if (LogFSWEvents)
                    Log.Information("FileSystemWatcher Ready.");
        }

        void ReadAllSettings()
        {
            try
            {
                LogFileReadyEvents = bool.Parse(ConfigValueProvider.Get("FSW:LogFileReadyEvents"));
                LogFSWEvents = bool.Parse(ConfigValueProvider.Get("FSW:LogFSWEvents"));
                FSWUseRegex = bool.Parse(ConfigValueProvider.Get("FSW:FSWUseRegex"));
                FSWRegex = ConfigValueProvider.Get("FSW:FSWRegex");
                WatchKinds = ConfigValueProvider.GetArray("FSW:WatchKinds");
                if (LogFSWEvents)
                    Log.Information($"[Event] Time: (DateTime.Now.TimeOfDay)\t LogFileReadyEvents:[{ LogFileReadyEvents}],LogFSWEvents:[{LogFSWEvents}]");
            }
            catch (Exception ex)
            {
                Log.Error(ex, "FileWatchExecutor.ReadAllSettings()");
            }
        }

        private void AddWatcher(string path, bool incSubDir = false)
        {
            bool watching = false;
            if (WatchKinds == null || !WatchKinds.Any())
                throw new InvalidOperationException("No watch action specified!");

            if (WatchKinds.Contains("Created") || WatchKinds.Contains("Deleted") || WatchKinds.Contains("Renamed"))
            {
                var watcher = new FileSystemWatcher();
                watcher.EnableRaisingEvents = false;
                watcher.IncludeSubdirectories = incSubDir;
                watcher.InternalBufferSize = 32768;
                watcher.Path = path;
                watcher.NotifyFilter = NotifyFilters.FileName | NotifyFilters.DirectoryName | NotifyFilters.CreationTime;
                watcher.Filter = "*.*";

                if (WatchKinds.Contains("Created"))
                    watcher.Created += async (s, e) => { await OnFileChanged(s, e); };
                if (WatchKinds.Contains("Deleted"))
                    watcher.Deleted += async (s, e) => { await OnFileChanged(s, e); };
                if (WatchKinds.Contains("Renamed"))
                    watcher.Renamed += async (s, e) => { await OnFileChanged(s, e); };

                watcher.EnableRaisingEvents = true;
                _fileSystemWatchers.Add(watcher);
                watching = true;
            }
            if (WatchKinds.Contains("Changed"))
            {
                var watcher2 = new FileChangedPolling(path, incSubDir);
                watcher2.Changed += async (s, e) => { await OnFileChanged(s, e); };
                _fileChangeds.Add(watcher2);
                watching = true;
            }
            if (LogFSWEvents && watching)
                Log.Information($"[Event] Time:{ DateTime.Now.TimeOfDay}\t Watching Folder: { path}");
        }
        private async Task OnFileChanged(object sender, FileSystemEventArgs e)
        {
            if (FSWUseRegex && !Regex.IsMatch(e.Name, FSWRegex))
                return;

            try
            {
                var f = new FileInfo(e.FullPath);
                if (_filteredFileTypes != null && !_filteredFileTypes.Any(str => f.Extension.Equals(str)))
                    return;

                var eventTime = DateTime.Now;
                string fileName = e.Name;
                if (LogFSWEvents)
                    Log.Information($"[Event] Time: {eventTime.TimeOfDay}\\t ChangeType: {e.ChangeType}\t FileName: {fileName}\t Path: {e.FullPath}");

                var res = await IsFileReadyAsync(e);
                if (res.Item1)
                {
                    OnFileReady?.Invoke(this, res.Item2);
                    if (LogFileReadyEvents)
                        Log.Information($"[Ready] Time :{DateTime.Now.TimeOfDay}\t ChangeType: {e.ChangeType} \t FileName:{fileName}");
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex, "FileWatchExecutor.OnFileChanged(...)");
            }
        }
        private ConcurrentDictionary<string, FileSystemEventArgs> NotReady = new ConcurrentDictionary<string, FileSystemEventArgs>();
        private async Task<Tuple<bool, FileSystemEventArgs>> IsFileReadyAsync(FileSystemEventArgs args)
        {
            if (args.ChangeType == WatcherChangeTypes.Deleted || args.ChangeType == WatcherChangeTypes.Renamed)
                return Tuple.Create(true, args);

            bool isWaiting = false;
            if (!NotReady.ContainsKey(args.FullPath))
            {
                if (!CheckReady(args.FullPath))
                    return Tuple.Create(true, args);
                isWaiting = NotReady.TryAdd(args.FullPath, args);
            }
            if (isWaiting)
            {
                while (!CheckReady(args.FullPath))
                    await Task.Delay(new TimeSpan(0, 0, 3));

                FileSystemEventArgs tmp;
                NotReady.TryRemove(args.FullPath, out tmp);
                return Tuple.Create(true, args);
            }
            return Tuple.Create(false, default(FileSystemEventArgs));
        }
        private bool CheckReady(string file)
        {
            try
            {
                using (var fs = File.Open(file, FileMode.Open, FileAccess.Read, FileShare.Read))
                    return true;
            }
            catch
            {
                return false;
            }

        }
    }
}
