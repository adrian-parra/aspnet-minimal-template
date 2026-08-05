using MinimalApi.Models;

namespace MinimalApi.Services;

public interface IJwtService
{
    string GenerateToken(User user);
}
