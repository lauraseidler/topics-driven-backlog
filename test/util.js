import Vue from 'vue';
import VueResource from 'vue-resource';

Vue.use(VueResource);

/**
 * Mock response body for tests of response body
 */
export const mockResponseBody = 'intercepted response body';

/**
 * Intercepts next HTTP request with given statusCode and response
 * @param {string} route
 * @param {string} method
 * @param {*} payload
 * @param {int} responseStatus
 * @param {*} responseBody
 * @returns {{correctMethod: boolean, correctRoute: boolean, correctPayload: boolean, correctRequest: boolean}}
 */
export function mockResponse(
    route = '/',
    method = 'GET',
    payload = null,
    responseStatus = 200,
    responseBody = mockResponseBody
) {
    const mockStatus = {
        correctMethod: false,
        correctRoute: false,
        correctPayload: true,
        correctRequest: false,
    };

    Vue.http.interceptors.push((request, next) => {
        if (request.method === method) {
            mockStatus.correctMethod = true;
        }

        if (request.url === route) {
            mockStatus.correctRoute = true;
        }

        if (
            payload &&
            JSON.stringify(request.body) !== JSON.stringify(payload)
        ) {
            mockStatus.correctPayload = false;
        }

        mockStatus.correctRequest =
            mockStatus.correctMethod &&
            mockStatus.correctRoute &&
            mockStatus.correctPayload;        

        next(
            request.respondWith(payload || responseBody, {
                status: responseStatus,
            })
        );
    });

    return mockStatus;
}
