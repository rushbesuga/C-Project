
using System.IO;

namespace FileWatcher.Contract
{
    public interface IFileWatchPlugin
    {
        void Exceute(string host, string absPath, string relPath, WatcherChangeTypes type);
    }
}
