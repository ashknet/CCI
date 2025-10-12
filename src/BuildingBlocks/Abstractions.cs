namespace BuildingBlocks;

public interface IEntity
{
    long Id { get; set; }
}

public interface IAggregateRoot {}

public abstract class AuditableEntity : IEntity
{
    public long Id { get; set; }
    public DateTime CreatedAtUtc { get; set; }
    public DateTime? UpdatedAtUtc { get; set; }
}

public record PagedResult<T>(IReadOnlyList<T> Items, int TotalCount, int Page, int PageSize);
