// const path = require('path');

// module.exports = ({ env }) => {
//   const client = postgres;

//   const connections = {
//     postgres: {
//       connection: {
//         host: env('DATABASE_HOST', 'localhost'),
//         port: env.int('DATABASE_PORT', 5432),
//         database: env('DATABASE_NAME', 'strapi'),
//         user: env('DATABASE_USERNAME', 'strapi'),
//         password: env('DATABASE_PASSWORD', 'strapi'),
//         ssl: env.bool('DATABASE_SSL', false) && {
//           key: env('DATABASE_SSL_KEY', undefined),
//           cert: env('DATABASE_SSL_CERT', undefined),
//           ca: env('DATABASE_SSL_CA', undefined),
//           capath: env('DATABASE_SSL_CAPATH', undefined),
//           cipher: env('DATABASE_SSL_CIPHER', undefined),
//           rejectUnauthorized: env.bool('DATABASE_SSL_REJECT_UNAUTHORIZED', true),
//         },
//         schema: env('DATABASE_SCHEMA', 'public'),
//       },
//       pool: {
//         min: env.int('DATABASE_POOL_MIN', 2),
//         max: env.int('DATABASE_POOL_MAX', 10),
//       },
//     },
//   };

  // console.log('Client value:', client);
  // console.log('Resolved config:', connections[client]);
  module.exports = () => ({
  connection: {
    client: 'postgres',
    connection: {
      host: 'strapi_postgres',     // 🔁 Change this if needed (e.g., RDS endpoint)
      port: 5432,
      database: 'strapi',
      user: 'strapi',
      password: 'strapi',
      ssl: false,
    },
    pool: {
      min: 2,
      max: 10,
    },
  },
});


  // return {
  //   connection: {
  //     client,
  //     ...selected,
  //     //acquireConnectionTimeout: env.int('DATABASE_CONNECTION_TIMEOUT', 60000),
  //   },
  // };

