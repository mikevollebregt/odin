using core_backend.Models;
using core_backend.Repositories;

namespace core_backend.Services
{
    public class ErrorService
    {
        private readonly IRepository<ErrorLog> _errorLogRepository;
        public List<string> Errors = new List<string>();
        public ErrorService(IRepository<ErrorLog> errorLogRepository) {
            _errorLogRepository = errorLogRepository;
        }

        public async Task<ErrorLog> SaveErrorLog(Exception exception)
        {
            var errorLog = new ErrorLog { InnerException = exception.InnerException.ToString(), Message = exception.Message };
            
            return await _errorLogRepository.AddAsync(errorLog);
        }

        public async Task<ErrorLog> SaveErrorLog(ErrorLog errorLog)
        {
            return await _errorLogRepository.AddAsync(errorLog);
        }
    }
}
