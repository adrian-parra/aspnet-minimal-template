using System.Data;
using Dapper;
using Microsoft.Extensions.Configuration;
using MySqlConnector;
using MinimalApi.Constants;
using MinimalApi.Models;

namespace MinimalApi.Repositories;

public class AuthRepository : IAuthRepository
{
    private readonly string _connectionString;

    public AuthRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("MySqlConnection") ??
            throw new InvalidOperationException("Connection string 'MySqlConnection' not found.");
    }

    private MySqlConnection CreateConnection() => new(_connectionString);

    public async Task<User?> RegisterAsync(User user)
    {
        using var connection = CreateConnection();
        var parameters = new DynamicParameters();
        parameters.Add("p_full_name", user.FullName);
        parameters.Add("p_email", user.Email);
        parameters.Add("p_password_hash", user.PasswordHash);
        parameters.Add("p_phone", user.Phone);
        parameters.Add("p_role_id", user.RoleId);

        var newUser = await connection.QueryFirstOrDefaultAsync<User>(
            StoredProcedures.UserRegister,
            parameters,
            commandType: CommandType.StoredProcedure
        );

        return newUser;
    }

    public async Task<User?> GetUserByEmailAsync(string email)
    {
        using var connection = CreateConnection();
        var parameters = new DynamicParameters();
        parameters.Add("p_email", email);

        var user = await connection.QueryFirstOrDefaultAsync<User>(
            StoredProcedures.UserByEmail,
            parameters,
            commandType: CommandType.StoredProcedure
        );

        return user;
    }
}
