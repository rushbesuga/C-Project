using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Linq;
using System.Text;
namespace Rabbitmq
{
    /// <summary>
    /// 訂閱者類別
    /// </summary>
    class Subscriber : IDisposable
    {
        private static ConnectionFactory _factory { get; set; }
        private static IConnection _connection { get; set; }
        private static IModel _channel { get; set; }

        private static readonly Lazy<Subscriber> _instance = new Lazy<Subscriber>(() => new Subscriber());

        public static Subscriber Instance
        {
            get
            {
                return _instance.Value;
            }
        }
        /// <summary>
        /// 主路由
        /// </summary>
        public string Exchange { get; set; }
        /// <summary>
        /// 多重子路由
        /// </summary>
        public string[] Routes { get; set; }

        private Subscriber() { }
        /// <summary>
        /// 建構子
        /// </summary>
        /// <param name="options">連線設定</param>
        /// <param name="exchange">主路由</param>
        /// <param name="routes">子路由</param>
        public Subscriber(FactoryOptions options, string exchange, string[] routes = null)
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
        /// <summary>
        /// 連線設定
        /// </summary>
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
        /// <summary>
        /// 訂閱
        /// </summary>
        /// <param name="notify">訂閱通知自訂處理</param>
        public void Sub(Action<string> notify)
        {
            // Server Type Fanout 無法使用子路由
            var exchangeType = ExchangeType.Topic;
            _channel.ExchangeDeclare(exchange: Exchange, type: exchangeType);
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
        /// <summary>
        /// 訂閱
        /// </summary>
        /// <param name="routes">子路由</param>
        /// <param name="notify">訂閱通知自訂處理</param>
        public void Sub(Action<string> notify, params string[] routes)
        {
            Routes = routes;
            Sub(notify);
        }
        /// <summary>
        /// 關閉並釋放訂閱連線
        /// </summary>
        public void Dispose()
        {
            _channel?.Dispose();
            _connection?.Dispose();
        }
    }
}
