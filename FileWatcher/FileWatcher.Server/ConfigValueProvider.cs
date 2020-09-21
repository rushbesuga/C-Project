using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Extensions.Configuration;
using Serilog;
using System.Diagnostics;
using System.IO;
using System.Linq;
namespace FileWatcher.Server
{
    public static class ConfigValueProvider
    {
        private static readonly IConfigurationRoot configuration;

        public static string BasePath { get; private set; }
        static ConfigValueProvider()
        {
            BasePath = Process.GetCurrentProcess().MainModule.FileName;
            if (File.Exists(BasePath))
                BasePath = Path.GetDirectoryName(BasePath);
            Log.Debug($"ConfigValueProvider baseDir=>{BasePath}");
            var builder = new ConfigurationBuilder()
         .SetBasePath(BasePath)
         .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);

            configuration = builder.Build();

        }
        public static string Get(string name)
        {
            try
            { return configuration[name]; }
            catch (Exception)
            {
                return null;
            }
        }
        public static List<string> GetArray(string arrName)
        {
            try
            {
                var myArray = configuration.GetSection(arrName).AsEnumerable();
                return myArray.Select(pair => pair.Value).Where(x => !String.IsNullOrEmpty(x)).ToList();
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
