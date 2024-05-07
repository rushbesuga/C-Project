using System;
using System.IO;
using System.Web.Script.Serialization;

namespace JOSE.Net
{
    public class JSSerializerMapper : IJsonMapper
    {
        private JavaScriptSerializer js;

        public JSSerializerMapper()
        {
            js = new JavaScriptSerializer();
        }

        public string Serialize(object obj)
        {
            return js.Serialize(obj);
        }

        public T Parse<T>(string json)
        {
            return js.Deserialize<T>(json);
        }
    }
}