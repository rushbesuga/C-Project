﻿using System;
using System.Collections.Generic;
using System.Text;
using RabbitMQ.Client;

namespace RabbitmqTest
{
    public class Publisher
    {
        private ConnectionFactory _factory { get; set; }
        private static readonly Lazy<Publisher> publisher = new Lazy<Publisher>(() => new Publisher());

        public static Publisher Instance
        {
            get { return publisher.Value; }
        }
        public string Exchange { get; set; }
        public string Route { get; set; }

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
                }
            }
        }
        private Publisher() { }
        /// <summary>
        /// 建構子
        /// </summary>
        /// <param name="options">連線設定</param>
        /// <param name="exchange">主路由</param>
        /// <param name="route">子路由</param>
        public Publisher(FactoryOptions options, string exchange, string route = "")
        {
            if (options == null)
                throw new ArgumentException("Factory options can't be null.");
            if (string.IsNullOrWhiteSpace(exchange))
                throw new ArgumentException("Exchange must be specified.");
            Options = options;
            Exchange = exchange;
            Route = route;
        }
        /// <summary>
        /// 立即發佈
        /// </summary>
        /// <param name="message">訊息</param>
        public void Pub(string message)
        {
            if (_factory == null)
                throw new ArgumentException("Factory is null, please provide options.");
            if (string.IsNullOrWhiteSpace(Exchange))
                throw new ArgumentException("Exchange must be specified.");

            using (IConnection connection = _factory.CreateConnection())
            {
                using (IModel channel = connection.CreateModel())
                {
                  var  exchangeType = ExchangeType.Topic; //supports routing
                    channel.ExchangeDeclare(
                        exchange: Exchange,
                        type: exchangeType,durable:true);

                    var props = channel.CreateBasicProperties();
                    props.Persistent = true;
                    byte[] body = Encoding.UTF8.GetBytes(message);
                    channel.BasicPublish(
                        exchange: Exchange,
                        routingKey: Route ?? "",
                        basicProperties: props,
                        body: body);
                }
            }
        }
        /// <summary>
        /// 立即發佈
        /// </summary>
        /// <param name="route">子路由</param>
        /// <param name="message">訊息</param>
        public void Pub(string route, string message)
        {
            Route = route;
            Pub(message);
        }
    }
}
