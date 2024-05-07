using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Stockstrategy.Model;
using System.Data;
using System.Collections.ObjectModel;
using OxyPlot.Series;
using OxyPlot;
using OxyPlot.Axes;

namespace Stockstrategy
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        //public PlotModel PlotModel { get; set; }

        public MainWindow()
        {
            InitializeComponent();
            DataContext = this;
            GetData();

            PlotModel = new PlotModel { Title = "Stock K-Line Chart" };

            PlotModel.InvalidatePlot(true);
            //var highLowSeries = new HighLowSeries
            //{
            //    Color = OxyColors.Red,
            //    StrokeThickness = 16,
            //    TrackerFormatString = "Date: {2:yyyy-MM-dd}\nHigh: {4}\nLow: {5}"

            //};

            //highLowSeries.Items.Add(new HighLowItem(DateTimeAxis.ToDouble(new DateTime(2023, 11, 30, 11, 0, 0)), 115, 98, 105, 98));

            //var xAxis = new DateTimeAxis
            //{
            //    Position = AxisPosition.Bottom,
            //    Title = "Time",
            //    MajorGridlineStyle = LineStyle.Solid,
            //    MinorGridlineStyle = LineStyle.Dot,
            //    StringFormat = "yyyy-MM-dd",
            //    IntervalLength = 100,
            //    MinorIntervalType = DateTimeIntervalType.Days,
            //    IntervalType = DateTimeIntervalType.Days,


            //    MinimumPadding = 0.1,
            //    MaximumPadding = 0.1,
            //};

            //var yAxis = new LinearAxis
            //{
            //    Position = AxisPosition.Left,
            //    Title = "Price",
            //    MajorGridlineStyle = LineStyle.Solid,
            //    MinorGridlineStyle = LineStyle.Dot,
            //    IntervalLength = 100,
            //    MinimumPadding = 100,
            //    MaximumPadding = 0.0,
            //    MajorStep = 5,
            //    MinorStep = 1
            //};
            //// 設置 Y 軸的價格顯示區間
            //yAxis.Minimum = 50; // 你希望的最小價格
            //yAxis.Maximum = 100; // 你希望的最大價格
            //                     //xAxis.AbsoluteMinimum = DateTimeAxis.ToDouble(DateTime.Now.AddMinutes(0.5));
            //                     //xAxis.AbsoluteMaximum = DateTimeAxis.ToDouble(DateTime.Now.AddMinutes(3.5));

            //PlotModel.Axes.Add(xAxis);
            //PlotModel.Axes.Add(yAxis);
            //PlotModel.Series.Add(highLowSeries);

        }

        private void MenuItem_Click(object sender, RoutedEventArgs e)
        {
            GetData();
        }
        void GetData()
        {
            DBStock dBStock = new DBStock();
            Data.ItemsSource = dBStock.GetStockInfos().AsDataView();
        }

        private void DataGridRow_MouseDoubleClick(object sender, MouseButtonEventArgs e)
        {
            var data = ((FrameworkElement)sender).DataContext as DataRowView;
            if (data != null)
            {
                DBStock dBStock = new DBStock();
                var stockK = dBStock.GetStockInfos(data.Row[0].ToString().Trim());
                Draw(stockK);
            }
        }
        static PlotModel PlotModel { get; set; }
        private void Draw(DataTable data)
        {

            PlotModel = new PlotModel { Title = "Stock K-Line Chart" };

            var highLowSeries = new HighLowSeries
            {
                Color = OxyColors.Red,
                StrokeThickness = 16,
                TrackerFormatString = "Date: {2:yyyy-MM-dd}\nHigh: {4}\nLow: {5}"

            };

            highLowSeries.Items.Add(new HighLowItem(DateTimeAxis.ToDouble(new DateTime(2023, 11, 30, 11, 0, 0)), 115, 98, 105, 98));

            var xAxis = new DateTimeAxis
            {
                Position = AxisPosition.Bottom,
                Title = "Time",
                MajorGridlineStyle = LineStyle.Solid,
                MinorGridlineStyle = LineStyle.Dot,
                StringFormat = "yyyy-MM-dd",
                IntervalLength = 100,
                MinorIntervalType = DateTimeIntervalType.Days,
                IntervalType = DateTimeIntervalType.Days,


                MinimumPadding = 0.1,
                MaximumPadding = 0.1,
            };

            var yAxis = new LinearAxis
            {
                Position = AxisPosition.Left,
                Title = "Price",
                MajorGridlineStyle = LineStyle.Solid,
                MinorGridlineStyle = LineStyle.Dot,
                IntervalLength = 100,
                MinimumPadding = 100,
                MaximumPadding = 0.0,
                MajorStep = 5,
                MinorStep = 1
            };
            // 設置 Y 軸的價格顯示區間
            yAxis.Minimum = 50; // 你希望的最小價格
            yAxis.Maximum = 100; // 你希望的最大價格
                                 //xAxis.AbsoluteMinimum = DateTimeAxis.ToDouble(DateTime.Now.AddMinutes(0.5));
                                 //xAxis.AbsoluteMaximum = DateTimeAxis.ToDouble(DateTime.Now.AddMinutes(3.5));

            PlotModel.Axes.Add(xAxis);
            PlotModel.Axes.Add(yAxis);
            PlotModel.Series.Add(highLowSeries);

            //PlotModel.Axes.Clear();
            // PlotModel.Series.Clear();
            //double maxprice = 0;
            //double minprice = 5000;
            //var highLowSeries = new HighLowSeries
            //{
            //    Color = OxyColors.Red,
            //    StrokeThickness = 16,
            //    TrackerFormatString = "Date: {2:yyyy-MM-dd}\nHigh: {4}\nLow: {5}"

            //};
            //foreach (DataRow row in data.Rows)
            //{

            //    if (Convert.ToDouble(row[1].ToString()) > maxprice)
            //        maxprice = Convert.ToDouble(row[1].ToString());
            //    if (Convert.ToDouble(row[2].ToString()) < minprice)
            //        minprice = Convert.ToDouble(row[2].ToString());

            //    DateTime dt = DateTime.Parse(row[0].ToString());
            // //   highLowSeries.Items.Add(new HighLowItem(DateTimeAxis.ToDouble(dt),  Convert.ToDouble( row[1].ToString()), Convert.ToDouble(row[2].ToString()), Convert.ToDouble(row[3].ToString()), Convert.ToDouble(row[1].ToString()))); 

            //}
            //highLowSeries.Items.Add(new HighLowItem(DateTimeAxis.ToDouble(new DateTime(2023, 11, 30, 11, 0, 0)), 115, 98, 105, 98));

            //var xAxis = new DateTimeAxis
            //{
            //    Position = AxisPosition.Bottom,
            //    Title = "Time",
            //    MajorGridlineStyle = LineStyle.Solid,
            //    MinorGridlineStyle = LineStyle.Dot,
            //    StringFormat = "yyyy-MM-dd",
            //    IntervalLength = 100,
            //    MinorIntervalType = DateTimeIntervalType.Days,
            //    IntervalType = DateTimeIntervalType.Days,


            //    MinimumPadding = 0.1,
            //    MaximumPadding = 0.1,
            //};

            //var yAxis = new LinearAxis
            //{
            //    Position = AxisPosition.Left,
            //    Title = "Price",
            //    MajorGridlineStyle = LineStyle.Solid,
            //    MinorGridlineStyle = LineStyle.Dot,
            //    IntervalLength = 100,
            //    MinimumPadding = 100,
            //    MaximumPadding = 0.0,
            //    MajorStep = 5,
            //    MinorStep = 1
            //};
            //// 設置 Y 軸的價格顯示區間
            //yAxis.Minimum = 50; // 你希望的最小價格
            //yAxis.Maximum = 100; // 你希望的最大價格
            //                     //xAxis.AbsoluteMinimum = DateTimeAxis.ToDouble(DateTime.Now.AddMinutes(0.5));
            //                     //xAxis.AbsoluteMaximum = DateTimeAxis.ToDouble(DateTime.Now.AddMinutes(3.5));

            //PlotModel.Axes.Add(xAxis);
            //PlotModel.Axes.Add(yAxis);
            //PlotModel.Series.Add(highLowSeries);

        }
    }
}
