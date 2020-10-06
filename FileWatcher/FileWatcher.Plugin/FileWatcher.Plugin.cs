using FileWatcher.Contract;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http.Headers;

namespace FileWatcher.Plugin
{
  public  class FileWatcher : IFileWatchPlugin
    {
        public void Exceute(string host, string absPath, string relPath, WatcherChangeTypes type)
        {
            Task.Run(() => MwExec(host, absPath, relPath, type)).Wait();
        }

        private async Task MwExec(string host, string absPath, string relPath, WatcherChangeTypes type)
        {
            // do something
        }
    }
}
