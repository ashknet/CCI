using Microsoft.EntityFrameworkCore;
using UserManagementService.Core.Entities;
using UserManagementService.Core.Interfaces;
using UserManagementService.Infrastructure.Data;

namespace UserManagementService.Infrastructure.Repositories;

public class UserRepository : IUserRepository
{
    private readonly UserManagementDbContext _context;

    public UserRepository(UserManagementDbContext context)
    {
        _context = context;
    }

    public async Task<User?> GetByIdAsync(Guid id)
    {
        return await _context.Users
            .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
            .Include(u => u.UserPreferences)
            .FirstOrDefaultAsync(u => u.Id == id);
    }

    public async Task<User?> GetByEmailAsync(string email)
    {
        return await _context.Users
            .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
            .Include(u => u.UserPreferences)
            .FirstOrDefaultAsync(u => u.Email == email.ToLower());
    }

    public async Task<IEnumerable<User>> GetAllAsync(int pageNumber, int pageSize)
    {
        return await _context.Users
            .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<User> CreateAsync(User user)
    {
        user.Email = user.Email.ToLower();
        _context.Users.Add(user);
        await _context.SaveChangesAsync();
        return user;
    }

    public async Task<User> UpdateAsync(User user)
    {
        _context.Users.Update(user);
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        return user;
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null) return false;

        user.IsActive = false;
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> ExistsAsync(string email)
    {
        return await _context.Users.AnyAsync(u => u.Email == email.ToLower());
    }

    public async Task<IEnumerable<Role>> GetUserRolesAsync(Guid userId)
    {
        return await _context.UserRoles
            .Where(ur => ur.UserId == userId)
            .Select(ur => ur.Role)
            .ToListAsync();
    }

    public async Task AddUserRoleAsync(Guid userId, Guid roleId)
    {
        var userRole = new UserRole
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            RoleId = roleId
        };

        _context.UserRoles.Add(userRole);
        await _context.SaveChangesAsync();
    }

    public async Task RemoveUserRoleAsync(Guid userId, Guid roleId)
    {
        var userRole = await _context.UserRoles
            .FirstOrDefaultAsync(ur => ur.UserId == userId && ur.RoleId == roleId);

        if (userRole != null)
        {
            _context.UserRoles.Remove(userRole);
            await _context.SaveChangesAsync();
        }
    }
}

public class RoleRepository : IRoleRepository
{
    private readonly UserManagementDbContext _context;

    public RoleRepository(UserManagementDbContext context)
    {
        _context = context;
    }

    public async Task<Role?> GetByIdAsync(Guid id)
    {
        return await _context.Roles.FindAsync(id);
    }

    public async Task<Role?> GetByNameAsync(string name)
    {
        return await _context.Roles.FirstOrDefaultAsync(r => r.Name == name.ToLower());
    }

    public async Task<IEnumerable<Role>> GetAllAsync()
    {
        return await _context.Roles.ToListAsync();
    }

    public async Task<Role> CreateAsync(Role role)
    {
        role.Name = role.Name.ToLower();
        _context.Roles.Add(role);
        await _context.SaveChangesAsync();
        return role;
    }

    public async Task<IEnumerable<Permission>> GetRolePermissionsAsync(Guid roleId)
    {
        return await _context.RolePermissions
            .Where(rp => rp.RoleId == roleId)
            .Select(rp => rp.Permission)
            .ToListAsync();
    }
}

public class SessionRepository : ISessionRepository
{
    private readonly UserManagementDbContext _context;

    public SessionRepository(UserManagementDbContext context)
    {
        _context = context;
    }

    public async Task<Session?> GetByRefreshTokenAsync(string refreshToken)
    {
        return await _context.Sessions
            .FirstOrDefaultAsync(s => s.RefreshToken == refreshToken && !s.IsRevoked && s.ExpiresAt > DateTime.UtcNow);
    }

    public async Task<Session> CreateAsync(Session session)
    {
        _context.Sessions.Add(session);
        await _context.SaveChangesAsync();
        return session;
    }

    public async Task RevokeAsync(Guid sessionId)
    {
        var session = await _context.Sessions.FindAsync(sessionId);
        if (session != null)
        {
            session.IsRevoked = true;
            await _context.SaveChangesAsync();
        }
    }

    public async Task RevokeAllUserSessionsAsync(Guid userId)
    {
        var sessions = await _context.Sessions.Where(s => s.UserId == userId).ToListAsync();
        foreach (var session in sessions)
        {
            session.IsRevoked = true;
        }
        await _context.SaveChangesAsync();
    }

    public async Task CleanupExpiredSessionsAsync()
    {
        var expiredSessions = await _context.Sessions
            .Where(s => s.ExpiresAt < DateTime.UtcNow || s.IsRevoked)
            .ToListAsync();

        _context.Sessions.RemoveRange(expiredSessions);
        await _context.SaveChangesAsync();
    }
}

public class NotificationRepository : INotificationRepository
{
    private readonly UserManagementDbContext _context;

    public NotificationRepository(UserManagementDbContext context)
    {
        _context = context;
    }

    public async Task<Notification?> GetByIdAsync(Guid id)
    {
        return await _context.Notifications.FindAsync(id);
    }

    public async Task<IEnumerable<Notification>> GetPendingNotificationsAsync(int batchSize)
    {
        return await _context.Notifications
            .Where(n => n.Status == "pending" && n.ScheduledFor <= DateTime.UtcNow)
            .OrderBy(n => n.ScheduledFor)
            .Take(batchSize)
            .ToListAsync();
    }

    public async Task<IEnumerable<Notification>> GetUserNotificationsAsync(Guid userId, int pageNumber, int pageSize)
    {
        return await _context.Notifications
            .Where(n => n.UserId == userId)
            .OrderByDescending(n => n.CreatedAt)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<Notification> CreateAsync(Notification notification)
    {
        _context.Notifications.Add(notification);
        await _context.SaveChangesAsync();
        return notification;
    }

    public async Task UpdateAsync(Notification notification)
    {
        _context.Notifications.Update(notification);
        await _context.SaveChangesAsync();
    }

    public async Task MarkAsReadAsync(Guid notificationId)
    {
        var notification = await _context.Notifications.FindAsync(notificationId);
        if (notification != null)
        {
            notification.ReadAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }
    }
}

public class UserPreferenceRepository : IUserPreferenceRepository
{
    private readonly UserManagementDbContext _context;

    public UserPreferenceRepository(UserManagementDbContext context)
    {
        _context = context;
    }

    public async Task<UserPreference?> GetByUserIdAsync(Guid userId)
    {
        return await _context.UserPreferences.FirstOrDefaultAsync(up => up.UserId == userId);
    }

    public async Task<UserPreference> CreateAsync(UserPreference preference)
    {
        _context.UserPreferences.Add(preference);
        await _context.SaveChangesAsync();
        return preference;
    }

    public async Task<UserPreference> UpdateAsync(UserPreference preference)
    {
        preference.UpdatedAt = DateTime.UtcNow;
        _context.UserPreferences.Update(preference);
        await _context.SaveChangesAsync();
        return preference;
    }
}

public class InsurancePolicyRepository : IInsurancePolicyRepository
{
    private readonly UserManagementDbContext _context;

    public InsurancePolicyRepository(UserManagementDbContext context)
    {
        _context = context;
    }

    public async Task<InsurancePolicy?> GetByIdAsync(Guid id)
    {
        return await _context.InsurancePolicies.FindAsync(id);
    }

    public async Task<IEnumerable<InsurancePolicy>> GetByUserIdAsync(Guid userId)
    {
        return await _context.InsurancePolicies
            .Where(ip => ip.UserId == userId)
            .OrderByDescending(ip => ip.CreatedAt)
            .ToListAsync();
    }

    public async Task<InsurancePolicy> CreateAsync(InsurancePolicy policy)
    {
        _context.InsurancePolicies.Add(policy);
        await _context.SaveChangesAsync();
        return policy;
    }

    public async Task<InsurancePolicy> UpdateAsync(InsurancePolicy policy)
    {
        policy.UpdatedAt = DateTime.UtcNow;
        _context.InsurancePolicies.Update(policy);
        await _context.SaveChangesAsync();
        return policy;
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var policy = await _context.InsurancePolicies.FindAsync(id);
        if (policy == null) return false;

        _context.InsurancePolicies.Remove(policy);
        await _context.SaveChangesAsync();
        return true;
    }
}

public class AuditLogRepository : IAuditLogRepository
{
    private readonly UserManagementDbContext _context;

    public AuditLogRepository(UserManagementDbContext context)
    {
        _context = context;
    }

    public async Task CreateAsync(AuditLog log)
    {
        _context.AuditLogs.Add(log);
        await _context.SaveChangesAsync();
    }

    public async Task<IEnumerable<AuditLog>> GetByUserIdAsync(Guid userId, int pageNumber, int pageSize)
    {
        return await _context.AuditLogs
            .Where(al => al.UserId == userId)
            .OrderByDescending(al => al.Timestamp)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<IEnumerable<AuditLog>> GetByResourceAsync(string resource, string resourceId)
    {
        return await _context.AuditLogs
            .Where(al => al.Resource == resource && al.ResourceId == resourceId)
            .OrderByDescending(al => al.Timestamp)
            .ToListAsync();
    }
}
