using System;
using System.Collections.Generic;
using System.Text;
using FileWatcher.Server.Modles;
using FileWatcher.Contract;
using Serilog;
using Microsoft.Extensions.Hosting;
using System.Threading.Tasks;
using System.Threading;
using System.IO;
using System.Reflection;
using System.Net;

namespace FileWatcher.Server
{
    public class FileWatcherService : IHostedService
    {
        static List<string> _sources;
        public Task StartAsync(CancellationToken cancellationToken)
        {
            _sources = ConfigValueProvider.GetArray("FSW:FSWSource");
            List<string> fileTypes = ConfigValueProvider.GetArray("FSW:FileTypes");
            bool incSubDir = false;
            bool.TryParse(ConfigValueProvider.Get("FSW:FSWSubDir"), out incSubDir);
            FileWatchExecutor.OnFileReady += OnFileReady;
            FileWatchExecutor.Instance.Watch(_sources.ToArray(), fileTypes, incSubDir);
            Log.Information($"[{nameof(FileWatcherService)}] has been started");
            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            Log.Information($"[{nameof(FileWatcherService)}] has been stopped");
            Thread.Sleep(1000);
            return Task.CompletedTask;
        }
        private static void OnFileReady(object sender, FileSystemEventArgs e)
        {
            string assem = ConfigValueProvider.Get("FSW:DynamicAssembly"), type = ConfigValueProvider.Get("FSW:DynamicType");
            ExecPlugin(assem, type, e);
        }
        private static bool isPluginDomainResolveOn;

        private static void ExecPlugin(string assembly, string type, FileSystemEventArgs e)
        {
            try
            {
                string assemPath = Path.Combine(ConfigValueProvider.BasePath, assembly);
                if (!File.Exists(assemPath))
                    throw new InvalidOperationException($"Invalid dynamic assembly path=>{assemPath}");
                if (!isPluginDomainResolveOn)
                {
                    AppDomain.CurrentDomain.AssemblyResolve += CurrentDomain_PluginAssemblyResolve;
                    isPluginDomainResolveOn = true;
                }
                IFileWatchPlugin plugin = (IFileWatchPlugin)Assembly.Load(File.ReadAllBytes(assemPath)).CreateInstance(type, true);
                plugin.Exceute(Dns.GetHostName(), e.FullPath, GetRelativePath(e.FullPath), e.ChangeType);
            }
            catch (Exception ex)
            {
                Log.Error(ex, "FileWatcherService.ExecPlugin(...)");
            }
        }
        private static Assembly CurrentDomain_PluginAssemblyResolve(object sender, ResolveEventArgs args)
        {
            string strTempAssmbPath = "";
            Assembly objPluginAsssenbly = args.RequestingAssembly;
            AssemblyName[] arrReferenceAssmbNames = objPluginAsssenbly.GetReferencedAssemblies();
            foreach (AssemblyName strAssmbName in arrReferenceAssmbNames)
            {
                if (strAssmbName.FullName.Substring(0, strAssmbName.FullName.IndexOf(",")) == args.Name.Substring(0, args.Name.IndexOf(",")))
                {
                    strTempAssmbPath = ConfigValueProvider.BasePath + "\\" + args.Name.Substring(0, args.Name.IndexOf(",")) + ".dll";
                    break;
                }
            }
            return Assembly
                .Load(File.ReadAllBytes(strTempAssmbPath));
        }

        private static string GetRelativePath(string absPath)
        {
            foreach (string source in _sources)
            {
                if (absPath.IndexOf(source) == 0)
                {
                    string rRoot = new DirectoryInfo(source).Name,
                            dir = Path.GetDirectoryName(absPath).Replace(source, string.Empty),
                            file = Path.GetFileName(absPath);
                    return rRoot + "\\" + Path.Combine(dir, file).TrimStart('\\');
                }
            }
            return absPath;
        }
    }
}
