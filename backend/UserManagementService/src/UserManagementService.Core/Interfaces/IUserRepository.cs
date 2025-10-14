using UserManagementService.Core.Entities;

namespace UserManagementService.Core.Interfaces;

public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id);
    Task<User?> GetByEmailAsync(string email);
    Task<IEnumerable<User>> GetAllAsync(int pageNumber, int pageSize);
    Task<User> CreateAsync(User user);
    Task<User> UpdateAsync(User user);
    Task<bool> DeleteAsync(Guid id);
    Task<bool> ExistsAsync(string email);
    Task<IEnumerable<Role>> GetUserRolesAsync(Guid userId);
    Task AddUserRoleAsync(Guid userId, Guid roleId);
    Task RemoveUserRoleAsync(Guid userId, Guid roleId);
}

public interface IRoleRepository
{
    Task<Role?> GetByIdAsync(Guid id);
    Task<Role?> GetByNameAsync(string name);
    Task<IEnumerable<Role>> GetAllAsync();
    Task<Role> CreateAsync(Role role);
    Task<IEnumerable<Permission>> GetRolePermissionsAsync(Guid roleId);
}

public interface ISessionRepository
{
    Task<Session?> GetByRefreshTokenAsync(string refreshToken);
    Task<Session> CreateAsync(Session session);
    Task RevokeAsync(Guid sessionId);
    Task RevokeAllUserSessionsAsync(Guid userId);
    Task CleanupExpiredSessionsAsync();
}

public interface INotificationRepository
{
    Task<Notification?> GetByIdAsync(Guid id);
    Task<IEnumerable<Notification>> GetPendingNotificationsAsync(int batchSize);
    Task<IEnumerable<Notification>> GetUserNotificationsAsync(Guid userId, int pageNumber, int pageSize);
    Task<Notification> CreateAsync(Notification notification);
    Task UpdateAsync(Notification notification);
    Task MarkAsReadAsync(Guid notificationId);
}

public interface IUserPreferenceRepository
{
    Task<UserPreference?> GetByUserIdAsync(Guid userId);
    Task<UserPreference> CreateAsync(UserPreference preference);
    Task<UserPreference> UpdateAsync(UserPreference preference);
}

public interface IInsurancePolicyRepository
{
    Task<InsurancePolicy?> GetByIdAsync(Guid id);
    Task<IEnumerable<InsurancePolicy>> GetByUserIdAsync(Guid userId);
    Task<InsurancePolicy> CreateAsync(InsurancePolicy policy);
    Task<InsurancePolicy> UpdateAsync(InsurancePolicy policy);
    Task<bool> DeleteAsync(Guid id);
}

public interface IAuditLogRepository
{
    Task CreateAsync(AuditLog log);
    Task<IEnumerable<AuditLog>> GetByUserIdAsync(Guid userId, int pageNumber, int pageSize);
    Task<IEnumerable<AuditLog>> GetByResourceAsync(string resource, string resourceId);
}
