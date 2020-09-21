using System;
using RabbitmqTest;
using System.Linq;
using System.Collections;
namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            var options = new FactoryOptions()
            {
                HostName = "JEPUN-PC076",
                HostPort = 5672,
                UserName = "Allen",
                UserPassword = "123",
                VirtualHost = "dev"
            };

            //ArrayList results = new ArrayList();
            //var subscriber = new Class1(options, "log");
            //subscriber.Sub((resp) =>
            //{
            //    results.Add(resp);
            //});
            //var subscriber2 = new Class1(options, "logs-serverity2");
            //subscriber2.Sub((resp) =>
            //{
            //    results.Add(resp);
            //}
            //, "warning", "warning.test", "critical.test1");
            //var subscriber3 = new Class1(options, "logs-serverity2");
            //subscriber3.Sub((resp) => { results.Add(resp); }, "warning.*");

            var msg = "hello word";
            var publisher = new Publisher(options, "log");
            var publisher2 = new Publisher(options, "logs-serverity2");
            publisher.Pub("mo rout");
            //publisher2.Pub("warning.test", msg);
            //subscriber.Dispose();
            //subscriber2.Dispose();
            Console.ReadLine();
        }
    }
}

