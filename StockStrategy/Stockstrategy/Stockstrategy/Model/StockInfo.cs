using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Stockstrategy.Model
{
    public class StockInfo
    {
        public DateTime date { get; set; }
        public double open { get; set; }
        public double high { get; set; }
        public double low { get; set; }
        public double close { get; set; }
        public double volume { get; set; }
    }
    public class StockMonthK
    {
        public string? stock_id { get; set; }
        public string? stock_name { get; set; }
        public string? monvol { get; set; }
        public string? ma36 { get; set; }

    }
}
