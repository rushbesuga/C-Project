<%@ WebHandler Language="C#" Class="Validation" %>

using System;
using System.Web;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Web.SessionState;
using System.Web.Services;

[WebService]
public class Validation : IHttpHandler, IRequiresSessionState {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/html";
        string rand = CreateRandomNum(4);
        context.Session["ValidateNum"] = rand;
        CreateImage(rand, context);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

    private string CreateRandomNum(int NumCount)
    {
        string allChar = "0,1,2,3,4,5,6,7,8,9";
        //string allChar = "0,1,2,3,4,5,6,7,8,9";
        string[] allCharArray = allChar.Split(','); //分成陣列
        string randomNum = "";
        int temp = -1; //紀錄上次亂數的數值，避免產生相同的亂數
        Random rand = new Random();
        for (int i = 0; i < NumCount; i++)
        {
            if (temp != -1)
            {
                rand = new Random(i * temp * ((int)DateTime.Now.Ticks));
            }
            int t = rand.Next(9);
            if (temp == t)
            {
                return CreateRandomNum(NumCount);
            }
            temp = t;
            randomNum += allCharArray[t];
        }
        return randomNum;
    }

    private void CreateImage(string validateNum, HttpContext context)
    {
        if (validateNum == null || validateNum.Trim() == String.Empty)
            return;
        //生成bitmap圖像
        Bitmap image = new Bitmap(validateNum.Length * 15 + 20, 35);
        Graphics g = Graphics.FromImage(image);
        try
        {
            Random random = new Random();
            g.Clear(Color.White);
            //畫圖片背景噪音線
            for (int i = 0; i < 20; i++)
            {
                int x1 = random.Next(image.Width);
                int x2 = random.Next(image.Width);
                int y1 = random.Next(image.Height);
                int y2 = random.Next(image.Height);
                g.DrawLine(new Pen(Color.Silver), x1, y1, x2, y2);
            }
            Font font = new Font("Arial", 15, (FontStyle.Bold | FontStyle.Italic));
            LinearGradientBrush brush = new LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), Color.ForestGreen, Color.DarkOliveGreen, 1.5f, true);
            g.DrawString(validateNum, font, brush, 5, 5);
            //畫圖片的前景噪音點
            for (int i = 0; i < 200; i++)
            {
                int x = random.Next(image.Width);
                int y = random.Next(image.Height);
                image.SetPixel(x, y, Color.FromArgb(random.Next()));
            }
            //畫圖片的邊框線
            g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            //將圖像保存到指定的流
            image.Save(ms, ImageFormat.Gif);
            context.Response.ClearContent();
            context.Response.ContentType = "image/Gif";
            context.Response.BinaryWrite(ms.ToArray());
        }
        finally
        {
            g.Dispose();
            image.Dispose();
        }
    }
}