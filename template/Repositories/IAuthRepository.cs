using MinimalApi.Models;

namespace MinimalApi.Repositories;

public interface IAuthRepository
{
    Task<User?> RegisterAsync(User user);
    Task<User?> GetUserByEmailAsync(string email);
}
