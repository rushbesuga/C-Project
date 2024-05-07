using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnitTests;
using JOSE.Net;
namespace ConsoleApp2
{
    class Program
    {
        private static string key = "i+iuoIB9B4ndSVAsjTT2D52gZ+93vnOWDvoTxFZ+LjI=";
        private static byte[] aes128Key = new byte[] { 194, 164, 235, 6, 138, 248, 171, 239, 24, 216, 11, 22, 137, 199, 215, 133 };
        static void Main(string[] args)
        {
            Byte[] bytesEncode = System.Text.Encoding.UTF8.GetBytes(key); //取得 UTF8 2進位 Byte
            string resultEncode = Convert.ToBase64String(bytesEncode); // 轉換 Base64 索引表
            byte[] encryptedBinary = Convert.FromBase64String(key);
            byte[] iv = new byte[16];

            Array.Copy(encryptedBinary, 0, iv, 0, 16);

            
            string json =
                @"{""reason_code"":""01"",""reason_memo"":""辦理客戶盡責審查""}";
            
            string token = new JWE(JweAlgorithm.A256GCMKW, JweEncryption.A128CBC_HS256, encryptedBinary, json).Serialize();
            
            Console.Out.WriteLine("A128GCMKW_A128CBC_HS256 = {0}", token);







            //given
            token = "eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiZGlyIn0..XjcOiriAd7gngS6YFj-MCw.dXT7y91tpt3HgNH8LdYad-bv84VHnOp1QD0UIqf_zQLjXeobOgJM7pgWciymnCCU54OZ7cLY8dljf5WbX3P71g.0ty2t8LKpamU1ma1Y662CA";
            //when
             json = JWT.Deserialize(token, null, encryptedBinary).Payload;

            //then
            Console.Out.WriteLine("json = {0}", json);
            Console.ReadLine();
        }
    
    }
}
