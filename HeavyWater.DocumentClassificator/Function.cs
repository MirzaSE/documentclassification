using System;
using Amazon.Comprehend;
using Amazon.Comprehend.Model;
using Amazon.Lambda.Core;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.Json.JsonSerializer))]

namespace HeavyWater.DocumentClassificator
{
    public class Function
    {
        
        /// <summary>
        /// A simple function that takes a string and does a ToUpper
        /// </summary>
        /// <param name="input"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public string FunctionHandler(JObject input, ILambdaContext context)
        {            
            AmazonComprehendClient comprehendClient = new AmazonComprehendClient(Amazon.RegionEndpoint.USEast1);

            var detectEntitiesRequest = new ClassifyDocumentRequest()
            {
                Text = input["Text"].ToString(),
                EndpointArn = Environment.GetEnvironmentVariable("DOCUMENT_CLASSIFICATION_ENDPOINT") 
            };

            var detectEntitiesResponse = comprehendClient.ClassifyDocumentAsync(detectEntitiesRequest).Result;

            var bestEntity = new DocumentClass();
        
            foreach (var e in detectEntitiesResponse.Classes)
            {
                if (e.Score > bestEntity.Score)
                {
                
                    bestEntity = e;
                }            
            }

            return JsonConvert.SerializeObject(bestEntity);
        }
    }
}
