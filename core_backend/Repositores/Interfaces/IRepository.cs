using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace core_backend.Repositories
{
    public interface IRepository<TEntity>
    {
        Task<List<TEntity>> GetAllAsync();
        Task<TEntity> FindByIdAsync(long id);

        Task<TEntity> FindByAsync(Expression<Func<TEntity, bool>> predicate);
        Task<List<TEntity>> FindAllByAsync(Expression<Func<TEntity, bool>> predicate);

        Task<TEntity> AddAsync(TEntity entity);

        Task DeleteAsync(TEntity entity);
        Task<TEntity> DeleteAsync(long id);

        Task<TEntity> UpdateAsync(TEntity entity);
        Task<int> CountAsync();
        Task<List<TEntity>> UpdateAsync(List<TEntity> entities);
        Task<List<TEntity>> AddAsync(List<TEntity> entities);
    }
}
