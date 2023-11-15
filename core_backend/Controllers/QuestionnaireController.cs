using core_backend.Models;
using core_backend.Repositories;
using core_backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace core_backend.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class QuestionnaireController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly IRepository<Questionnaire> _questionnaireRepository;

        public QuestionnaireController(UserService userService, IRepository<Questionnaire> questionnaireRepository)
        {
            _userService = userService;
            _questionnaireRepository = questionnaireRepository;
        }

        [HttpPost]
        public async Task<IActionResult> AddQuestionnaire([FromBody] Questionnaire questionnaire)
        {
            var user = await _userService.GetLoggedInUser();

            questionnaire.UserId = user.Id;

            await _questionnaireRepository.AddAsync(questionnaire);

            return Ok(questionnaire);
        }
    }
}
