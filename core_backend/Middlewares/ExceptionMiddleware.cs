using core_backend.Exceptions;
using core_backend.Models;
using core_backend.Models.DTOs;
using core_backend.Services;
using System.Net;

namespace core_backend.Middlewares
{
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;

        public ExceptionMiddleware(RequestDelegate next)
        {

            _next = next;
        }

        public async Task InvokeAsync(HttpContext httpContext, ErrorService errorLogService, UserService userService)
        {

            try
            {
                await _next(httpContext);
            }
            catch (Exception ex)
            {
                Console.WriteLine("##### ERROR #####");
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.StackTrace);
                Console.WriteLine("-----------------");

                await HandleExceptionAsync(httpContext, ex, errorLogService, userService);
            }
        }

        private async Task<Task> HandleExceptionAsync(HttpContext context, Exception exception, ErrorService errorLogService, UserService userService)
        {
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

            var bodyStream = new StreamReader(context.Request.Body);

            if (context.Request.Body.CanSeek)
            {
                bodyStream.BaseStream.Seek(0, SeekOrigin.Begin);
            }

            var bodyText = await bodyStream.ReadToEndAsync();


            return context.Response.WriteAsync(exception.ToString());

        }


    }
}
