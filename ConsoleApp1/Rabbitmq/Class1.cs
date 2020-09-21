using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
namespace Rabbitmq
{

    public class Class1 : IDisposable
    {
        private static ConnectionFactory _factory { get; set; }
        private static IConnection _connection { get; set; }
        private static IModel _channel { get; set; }

        private static readonly Lazy<Class1> _instance = new Lazy<Class1>(() => new Class1());

        public static Class1 Instance
        {
            get
            {
                return _instance.Value;
            }
        }
        public string Exchange { get; set; }

        public string[] Routes { get; set; }

        private Class1() { }

        public Class1(FactoryOptions options, string exchange, string[] routes = null)
        {
            if (options == null)
                throw new ArgumentException("Factory options can't be null!");
            if (string.IsNullOrWhiteSpace(exchange))
                throw new ArgumentException("Exchange must be specified.");
            Options = options;
            Exchange = exchange;
            Routes = routes;
        }

        private FactoryOptions _options;

        public FactoryOptions Options
        {
            get
            {
                return _options;
            }
            set
            {
                _options = value;
                if (_options != null)
                {
                    _factory = new ConnectionFactory()
                    {
                        HostName = _options.HostName,
                        Port = _options.HostPort,
                        VirtualHost = _options.VirtualHost,
                        UserName = _options.UserName,
                        Password = _options.UserPassword
                    };
                    if (_connection == null)
                        _connection = _factory.CreateConnection();
                    if (_channel == null)
                        _channel = _connection.CreateModel();
                }
            }
        }
        public void Sub(Action<string> notify)
        {
            // Server Type Fanout 無法使用子路由
            var exchangeType = ExchangeType.Topic;
            _channel.ExchangeDeclare(exchange: Exchange, type: exchangeType, false, false);
            string queueName = _channel.QueueDeclare().QueueName;
            if (Routes != null && Routes.Count() > 0)
                foreach (string route in Routes)
                    _channel.QueueBind(queue: queueName, exchange: Exchange, routingKey: route);
            else
                _channel.QueueBind(queue: queueName, exchange: Exchange, routingKey: "");
            var consumer = new EventingBasicConsumer(_channel);
            consumer.Received += (model, ea) =>
            {
                byte[] body = ea.Body;
                string message = Encoding.UTF8.GetString(body.ToArray());
                notify?.Invoke(message);
            };
            _channel.BasicConsume(queue: queueName, autoAck: true, consumer: consumer);
        }
        public void Sub(Action<string> notify, params string[] routes)
        {
            Routes = routes;
            Sub(notify);
        }
        public void Dispose()
        {
            _channel?.Dispose();
            _connection?.Dispose();
        }
    }
}
