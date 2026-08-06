using System.Threading.Tasks;
using MinimalApi.Common;
using MinimalApi.Dtos;
using MinimalApi.Models;
using MinimalApi.Repositories;

namespace MinimalApi.Services;

public class AuthServices : IAuthServices
{
    private readonly IAuthRepository _authRepository;
    private readonly IJwtService _jwtService;

    public AuthServices(IAuthRepository authRepository, IJwtService jwtService)
    {
        _authRepository = authRepository;
        _jwtService = jwtService;
    }

    public async Task<Result<UserResponseDto>> RegisterUserAsync(UserRegisterDto userRegisterDto)
    {
        // 🔐 Encriptar la contraseña usando BCrypt
        string hashedPassword = BCrypt.Net.BCrypt.HashPassword(userRegisterDto.Password);

        var user = new User
        {
            FullName = userRegisterDto.FullName,
            Email = userRegisterDto.Email,
            PasswordHash = hashedPassword,
            Phone = userRegisterDto.Phone,
            RoleId = userRegisterDto.RoleId
        };

        var newUser = await _authRepository.RegisterAsync(user);

        if (newUser == null)
        {
            return Result<UserResponseDto>.Failure("Error al registrar el usuario");
        }

        return Result<UserResponseDto>.Success(newUser.ToResponseDto());
    }

    public async Task<Result<AuthResponseDto>> LoginUserAsync(UserLoginDto userLoginDto)
    {
        var user = await _authRepository.GetUserByEmailAsync(userLoginDto.Email);

        if (user == null)
        {
            return Result<AuthResponseDto>.Failure("Credenciales inválidas", statusCode: 400);
        }

        if (!BCrypt.Net.BCrypt.Verify(userLoginDto.Password, user.PasswordHash))
        {
            return Result<AuthResponseDto>.Failure("Credenciales inválidas", statusCode: 400);
        }

        string token = _jwtService.GenerateToken(user);

        return Result<AuthResponseDto>.Success(new AuthResponseDto
        {
            Token = token,
            User = user.ToResponseDto()
        });
    }
}
