import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    cors: {
      origin: [
        "http://localhost:3000",
        "http://localhost:3001"
      ]
    }
  });
  await app.listen(8080);
}
bootstrap();
