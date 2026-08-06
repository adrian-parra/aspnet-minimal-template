using System.Threading.Tasks;
using MinimalApi.Common;
using MinimalApi.Dtos;

namespace MinimalApi.Services;

public interface IAuthServices
{
    Task<Result<UserResponseDto>> RegisterUserAsync(UserRegisterDto userRegisterDto);
    Task<Result<AuthResponseDto>> LoginUserAsync(UserLoginDto userLoginDto);
}
