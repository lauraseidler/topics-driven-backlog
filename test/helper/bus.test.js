// spy on console warnings
jest.spyOn(console, 'info').mockImplementation(text => text);

import bus from '@/helper/bus';
import Vue from 'vue';

describe('bus.test.js', () => {
    it('is a vue instance', () => {
        expect(bus instanceof Vue).toBe(true);
    });
});
