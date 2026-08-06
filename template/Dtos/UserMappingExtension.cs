using MinimalApi.Models;

namespace MinimalApi.Dtos;

public static class UserMappingExtension
{
    public static UserResponseDto ToResponseDto(this User user)
    {
        return new UserResponseDto
        {
            Id = user.Id,
            FullName = user.FullName,
            Email = user.Email,
            Phone = user.Phone,
            RoleId = user.RoleId,
            Role = user.Role,
            IsActive = user.IsActive,
            IsDeleted = user.IsDeleted,
            DeletedAt = user.DeletedAt,
            CreatedAt = user.CreatedAt,
            UpdatedAt = user.UpdatedAt
        };
    }
}
