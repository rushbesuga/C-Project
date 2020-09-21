﻿using System;
using System.Collections.Generic;
using System.Text;

namespace RabbitmqTest
{
    public class FactoryOptions
    {
        public string HostName { get; set; }
        public int HostPort { get; set; }
        public string UserName { get; set; }
        public string UserPassword { get; set; }
        public string VirtualHost { get; set; }
    }
}
