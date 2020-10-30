using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Rabbitmq;
namespace Clinet
{
    class Program
    {
        static void Main(string[] args)
        {

                var options = new FactoryOptions()
            {
                HostName = "Allen-PC076",
                HostPort = 5672,
                UserName = "Allen",
                UserPassword = "123",
                VirtualHost = "dev"
            };

            var msg = "hello word";
            var publisher = new Publisher(options, "log");
            var publisher2 = new Publisher(options, "logs-serverity2");
            publisher.Pub("mo rout");

            Console.ReadLine();
        }
        
    }
}
