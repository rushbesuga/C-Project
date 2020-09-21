using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RabbitmqTest;
namespace ConsoleApp2
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var options = new FactoryOptions()
                {
                    HostName = "JEPUN-PC076",
                    HostPort = 5672,
                    UserName = "Allen",
                    UserPassword = "123",
                    VirtualHost = "dev"
                };
                var subscriber = new Class1(options, "log");
                subscriber.Sub((resp) =>
                 {
                     Console.WriteLine(resp.ToString());
                 });
                Console.ReadLine();
                subscriber.Dispose();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
    }
}
