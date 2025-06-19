console.log("✅ Reached database.js file"); 

module.exports = ({ env }) => {
  const client = env('DATABASE_CLIENT');

  const connections = {
    postgres: {
      connection: {
        host: env('DATABASE_HOST'),
        port: env.int('DATABASE_PORT'),
        database: env('DATABASE_NAME'),
        user: env('DATABASE_USERNAME'),
        password: env('DATABASE_PASSWORD'),
        ssl: false,
        schema: env('DATABASE_SCHEMA', 'public'),
      },
      pool: {
        min: env.int('DATABASE_POOL_MIN', 2),
        max: env.int('DATABASE_POOL_MAX', 10),
      },
    },
  };

  const config = connections[client];
  if (!config) {
    throw new Error(`Database client "${client}" is not supported.`);
  }

  return {
    connection: {
      client,
      ...config,
      acquireConnectionTimeout: env.int('DATABASE_CONNECTION_TIMEOUT', 60000),
    },
  };
};