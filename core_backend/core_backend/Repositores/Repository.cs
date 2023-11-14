using core_backend.Data;
using core_backend.Exceptions;
using core_backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace core_backend.Repositories
{
    public class Repository<TEntity> : IRepository<TEntity> where TEntity : class
    {
        protected readonly ApplicationDbContext _database;

        public Repository(ApplicationDbContext database)
        {
            _database = database;
        }

        /// <summary>
        /// Gets all entities without tracking them.
        /// </summary>
        public virtual async Task<List<TEntity>> GetAllAsync()
        {
            return await _database.Set<TEntity>().AsNoTracking().ToListAsync();
        }

        /// <summary>
        /// returns entity by primary key Id
        /// </summary>
        /// <param name="entityId">Primary key id.</param>
        /// <exception cref="RepositoryException">Id does not exist in the database</exception>
        public virtual async Task<TEntity> FindByIdAsync(long id)
        {
            if (id <= 0)
            {
                throw new RepositoryException("FindById Repository", "Id does not exist in the database", 500);
            }

            return await _database.Set<TEntity>().FindAsync(id);
        }

        /// <summary>
        /// returns entity or null when nothing is found.
        /// </summary>
        /// <param name="predicate">Predicate filter</param>
        public virtual async Task<TEntity> FindByAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await _database.Set<TEntity>().FirstOrDefaultAsync(predicate);
        }


        /// <summary>
        /// returns list of entities based on predicate.
        /// </summary>
        /// <param name="predicate">Predicate filter</param>
        public virtual async Task<List<TEntity>> FindAllByAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await _database.Set<TEntity>().Where(predicate).ToListAsync();
        }


        /// <summary>
        /// Adds entity to database
        /// </summary>
        /// <param name="entity">Entity object</param>
        /// <exception cref="RepositoryException">"Can't search an null entity"</exception>
        /// <exception cref="Exception">"General exceptions"</exception>
        public virtual async Task<TEntity> AddAsync(TEntity entity)
        {
            if (entity == null)
            {
                throw new RepositoryException("AddAsync Repository", "Can't add a null entity", 500);
            }

            try
            {
                (entity as BaseModel).Created = DateTime.Now;
                (entity as BaseModel).Updated = null;
                (entity as BaseModel).Deleted = null;
                await _database.AddAsync(entity);
                await SaveChangesAsync();
            }
            catch (Exception ex)
            {
                //TODO:: Throw specific errors

                // Catch anything else
                throw;
            }

            return entity;
        }

        /// <summary>
        /// Deletes entitiy in database
        /// </summary>
        /// <param name="entity">Entity object</param>
        /// <exception cref="RepositoryException">"Can't search an null entity"</exception>
        /// <exception cref="Exception">"General exceptions"</exception>
        public virtual async Task DeleteAsync(TEntity entity)
        {
            if (entity == null)
            {
                throw new RepositoryException("DeleteAsync Repository", "Can't search an null entity", 500);
            }

            try
            {
                (entity as BaseModel).Deleted = DateTime.Now;
                _ = await Task.Run(() => _database.Update(entity));
                await SaveChangesAsync();
            }
            catch (Exception ex)
            {
                //TODO:: Throw specific errors

                // Catch anything else
                throw;
            }
        }

        /// <summary>
        /// Deletes entitiy in database
        /// </summary>
        /// <param name="Id">Primary id of object</param>
        /// <exception cref="RepositoryException">"Can't search an null entity"</exception>
        /// <exception cref="RepositoryException">"Entity with id: " + id + "did not exist"</exception>
        /// <exception cref="Exception">"General exceptions"</exception>
        public virtual async Task<TEntity> DeleteAsync(long Id)
        {
            if (Id <= 0)
            {
                throw new RepositoryException("DeleteAsync Repository", "Id does not exist in the database", 500);
            }

            var entity = await _database.Set<TEntity>().FindAsync(Id);

            if (entity == null)
            {
                throw new RepositoryException("DeleteAsync Repository", "Entity with id: " + Id + "did not exist", 500);
            }

            try
            {
                (entity as BaseModel).Deleted = DateTime.Now;
                await Task.Run(() => _database.Update(entity));
                await SaveChangesAsync();
            }
            catch (Exception ex)
            {
                //TODO:: Throw specific errors

                // Catch anything else
                throw;
            }

            return entity;
        }

        /// <summary>
        /// Updates entitiy in database
        /// </summary>
        /// <param name="Id">Primary id of object</param>
        /// <exception cref="RepositoryException">"Can't search an null entity"</exception>
        /// <exception cref="Exception">"General exceptions"</exception>
        public virtual async Task<TEntity> UpdateAsync(TEntity entity)
        {
            if (entity == null)
            {
                throw new RepositoryException("UpdateAsync Repository", "Can't search an null entity", 500);
            }

            try
            {
                (entity as BaseModel).Updated = DateTime.Now;
                _database.Update(entity);
                await SaveChangesAsync();
            }
            catch (Exception ex)
            {
                //TODO:: Throw specific errors

                // Catch anything else
                throw;
            }
            return entity;
        }

        private async Task SaveChangesAsync()
        {
            await _database.SaveChangesAsync();
        }

        /// <summary>
        /// Addes entities in database
        /// </summary>
        /// <param name="Id">List of entities</param>
        /// <exception cref="RepositoryException">"Can't search an null entity"</exception>
        /// <exception cref="Exception">"General exceptions"</exception>
        public virtual async Task<List<TEntity>> AddAsync(List<TEntity> entities)
        {
            if (entities is null || entities.Count == 0)
            {
                throw new ArgumentNullException(nameof(entities), "Can't search an null entity");
            }

            try
            {
                entities.ForEach(entity => (entity as BaseModel).Created = DateTime.Now);

                await _database.AddRangeAsync(entities);
                await _database.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                //TODO:: Throw specific errors

                // Catch anything else
                throw;
            }

            return entities;
        }

        /// <summary>
        /// Updates entities in database
        /// </summary>
        /// <param name="Id">List of entities</param>
        /// <exception cref="RepositoryException">"Can't search an null entity"</exception>
        /// <exception cref="Exception">"General exceptions"</exception>
        public virtual async Task<List<TEntity>> UpdateAsync(List<TEntity> entities)
        {
            if (entities is null || entities.Count == 0)
            {
                throw new ArgumentNullException(nameof(entities), "Can't search an null entity");
            }

            try
            {
                entities.ForEach(entity => (entity as BaseModel).Updated = DateTime.Now);
                await Task.Run(() => _database.UpdateRange(entities));
                await _database.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                //TODO:: Throw specific errors

                // Catch anything else
                throw;
            }

            return entities;
        }

        public async Task<int> CountAsync()
        {
            return await _database.Set<TEntity>().CountAsync();
        }

        /// <summary>
        /// returns count of entities based on predicate.
        /// </summary>
        /// <param name="predicate">Predicate filter</param>
        public virtual async Task<int> CountAsync(Expression<Func<TEntity, bool>> predicate)
        {
            return await _database.Set<TEntity>().Where(predicate).CountAsync();
        }
    }
}
