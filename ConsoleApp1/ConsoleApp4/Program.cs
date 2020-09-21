using System;
using System.IO;
namespace ConsoleApp4
{
    class Program
    {
        static void Main(string[] args)
        {
            FileStream fileStream = new FileStream("C:\\Users\\AllenYu\\AppData\\Roaming\\RabbitMQ\\db\\rabbit@JEPUN-PC076-mnesia\\msg_stores\\vhosts\\DPC7KP7WBND5MYPZUVRYRSA6A\\queues\\E4EMQQGEED2M5RJB2YX12DCDI\\0.idx", FileMode.Open);
            BinaryReader binaryReader = new BinaryReader(fileStream);

            int[] intArray = new int[100];
            int point = 0;
            while (binaryReader.BaseStream.Position < binaryReader.BaseStream.Length)
            {
                int intNow = binaryReader.ReadByte();
                intArray[point] = intNow;
                if (intNow == 00)
                {
                    int intoffset = word_offset(binaryReader.ReadBytes(4));
                    int length = word_length(binaryReader.ReadBytes(4));
                    Console.WriteLine(word_str(intArray, point).ToString() + "\\n" + getvocabularyinformation(binaryReader, intoffset, length).ToString()); 
                     point = 0;
                    break;
                }
                point++;
              
            }

            String word_str(int[] intArray, int intEnd)
            {
                String word = "";
                for (int intX = 0; intX < intEnd; intX++)
                {
                    if (intArray[intX] != 00)
                    {
                        word += Convert.ToChar(intArray[intX]);
                    }
                }
                return word;
            }

             int word_offset(byte[] byteArray)
            {
                int offset = 0;
                String strHex = "";
                for (int intX = 0; intX < byteArray.Length; intX++)
                {
                    strHex += Convert.ToString(byteArray[intX], 16).PadLeft(2, '0');
                }
                offset = Convert.ToInt32(strHex, 16);
                return offset;
            }

             int word_length(byte[] byteArray)
            {
                int length = 0;
                String strHex = "";
                for (int intX = 0; intX < byteArray.Length; intX++)
                {
                    strHex += Convert.ToString(byteArray[intX], 16).PadLeft(2, '0');
                }
                length = Convert.ToInt32(strHex, 16);
                return length;
            }
             String getvocabularyinformation(BinaryReader objBR, int intO, int intL)
            {
                String strX = "";
                while (objBR.BaseStream.Position < objBR.BaseStream.Length)
                {
                    objBR.BaseStream.Position = intO;
                    byte[] objBytes = objBR.ReadBytes(intL);
                    strX = System.Text.Encoding.UTF8.GetString(objBytes);

                    strX = strX.Replace("\n", "\\n");

                    //Console.WriteLine(strX);
                    break;
                }
                return strX;
            }
        }
      
    }
}
