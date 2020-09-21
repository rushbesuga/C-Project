using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
namespace FileWatcher.Server
{
    class Program
    {
        static async Task Main(string[] args)
        {
            SetupStaticLogger(); // Serilog

            try
            {
                var builder = new HostBuilder()
                .UseSerilog()
                .ConfigureServices((hostContext, services) =>
                {
                    services.AddHostedService<FileWatcherService>();
                });

                // Run with console or service
                var asService = !(Debugger.IsAttached || args.Contains("--console"));

                builder.UseEnvironment(asService ? Environments.Production : Environments.Development);

                if (asService)
                    await builder.RunAsServiceAsync();
                else
                    await builder.RunConsoleAsync();
            }
            catch (Exception ex)
            {
                Log.Fatal(ex, "Unhandled exception.");
            }
            finally
            {
                Log.CloseAndFlush();
            }
        }

        static void SetupStaticLogger()
        {
            var configuration = new ConfigurationBuilder()
                .AddJsonFile(Path.Combine(ConfigValueProvider.BasePath, "loggerconfig.json"))
                .Build();

            Log.Logger = new LoggerConfiguration()
                .ReadFrom
                .Configuration(configuration)
                .CreateLogger();
        }
    }
}

