import { Injectable } from '@angular/core';
import { loggingInRequest, loggingInResponse } from 'src/utils/generated/auth_pb';
import { AuthManagerClient, ServiceError } from 'src/utils/generated/auth_pb_service';
import { grpc } from '@improbable-eng/grpc-web';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private client: AuthManagerClient;

  constructor() {
    this.client = new AuthManagerClient(environment.urlGrpcVaultServer); 
  }

  login(email: string, password: string): Promise<string> {
    const request = new loggingInRequest();
    request.setEmail(email);
    request.setPass(password);

    const metadata = new grpc.Metadata(); 

    return new Promise((resolve, reject) => {
      this.client.loggingIn(
        request,
        metadata,
        (error: ServiceError | null, response: loggingInResponse | null) => {
          if (error) {
            console.error('gRPC Service Error:', error.message);
            reject(new Error(`gRPC Error: ${error.message} (Code: ${error.code})`));
          } else if (response) {
            console.log('gRPC Response:', response.toObject());
            resolve(response.getRes());
          } else {
            reject(new Error('No response received from the server.'));
          }
        }
      );
    });
  }
}
