using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Dapr.Client;
using Dapr.Extensions.Configuration;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace SecretsDemo
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration(config =>
                {
                    var secretStore = "cloud-secret-store";
                    var daprClient = new DaprClientBuilder().Build();

                    // Only get specific secrets from secret store
                    // config.AddDaprSecretStore(secretStore, new List<DaprSecretDescriptor>
                    // {
                    //     new DaprSecretDescriptor("TestConnectionString"),
                    //     new DaprSecretDescriptor("TestSecret")
                    // }, daprClient);

                    // Get entire secret store
                    config.AddDaprSecretStore(secretStore, daprClient);
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
