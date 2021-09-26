using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(SoilAndWaterConservation.Startup))]
namespace SoilAndWaterConservation
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
