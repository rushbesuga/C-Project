using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Extensions.Hosting;
using System.ServiceProcess;
using System.Threading;
using System.Threading.Tasks;

namespace FileWatcher.Server
{
    public class FwServiceBase : ServiceBase, IHostLifetime
    {
        private readonly TaskCompletionSource<object> _delayStart;

        private IHostApplicationLifetime hostApplicationLifetime { get; }
        public FwServiceBase(IHostApplicationLifetime hostApplicationLifetime)
        {
            _delayStart = new TaskCompletionSource<object>();
            hostApplicationLifetime = hostApplicationLifetime ?? throw new ArgumentNullException(nameof(hostApplicationLifetime));
        }
        public Task StopAsync(CancellationToken cancellationToken)
        {
            Stop();
            return Task.CompletedTask;
        }
        public Task WaitForStartAsync(CancellationToken cancellationToken)
        {
            cancellationToken.Register(() => _delayStart.TrySetCanceled());
            hostApplicationLifetime.ApplicationStopping.Register(Stop);
            new Thread(Run).Start();
            return _delayStart.Task;
        }

        private void Run()
        {
            try
            {
                Run(this);
                _delayStart.TrySetException(new InvalidOperationException("Stopped without starting"));
            }
            catch (Exception ex)
            {
                _delayStart.TrySetException(ex);
            }
        }
        protected override void OnStart(string[] args)
        {
            _delayStart.TrySetResult(null);
            base.OnStart(args);
        }
        protected override void OnStop()
        {
            hostApplicationLifetime.StopApplication();
            base.OnStop();
        }
        protected override void OnPause()
        {
            base.OnPause();
        }
        protected override void OnContinue()
        {
            base.OnContinue();
        }

    }
}
