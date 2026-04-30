/**
 * Tests for APIClient
 */

import { jest } from '@jest/globals';
import { APIClient } from './api-client.js';

describe('APIClient', () => {
  describe('restartServer', () => {
    it('should restart using the previous server config after stop clears state', async () => {
      const client = new APIClient({
        serverPath: './src/interfaces/api/server.js',
        defaultPort: 8080,
        defaultHost: 'localhost',
      });

      client.serverProcess = { pid: 1234 };
      client.serverConfig = {
        port: 4321,
        host: '127.0.0.1',
        daemon: true,
      };

      const stopServer = jest
        .spyOn(client, 'stopServer')
        .mockImplementation(async () => {
          client.serverProcess = null;
          client.serverConfig = null;
        });
      const startServer = jest
        .spyOn(client, 'startServer')
        .mockResolvedValue({ restarted: true });

      await client.restartServer();

      expect(stopServer).toHaveBeenCalledTimes(1);
      expect(startServer).toHaveBeenCalledTimes(1);
      expect(startServer).toHaveBeenCalledWith({
        port: 4321,
        host: '127.0.0.1',
        daemon: true,
      });
    });
  });
});
