// spy on console warnings
const consoleSpy = jest.spyOn(console, 'info').mockImplementation(text => text);

import { mockResponse } from '../util';
import '@/packs/application.js';

// mock responses with empty arrays to prevent promise errors
mockResponse(null, null, []);

// div to mount app needs to be created manually
const div = document.createElement('div');
div.setAttribute('id', 'app');
document.body.appendChild(div);

// DOMContentLoaded event needs to be fired manually
const domLoadedEvent = document.createEvent('Event');
domLoadedEvent.initEvent('DOMContentLoaded', true, true);
window.document.dispatchEvent(domLoadedEvent);

import Vue from 'vue';

describe('application.test.js', () => {
    let cmp;

    beforeAll(() => {
        cmp = document.getElementById('app').__vue__;
    });

    it('logs warning about development mode', () => {
        expect(consoleSpy).toBeCalledWith(
            expect.stringContaining('You are running Vue in development mode.')
        );
    });

    it('has initialised vue instance on #app div', () => {
        expect(cmp instanceof Vue).toBe(true);
    });

    it('has initialised store', () => {
        expect(cmp.$store).toBeTruthy();
        expect(cmp.$store.state.initialised).toBe(true);
    });

    it('has initialised router', () => {
        expect(cmp.$router).toBeTruthy();
    });

    it('has loaded plugins', () => {
        expect(cmp.$http).toBeTruthy();
    });
});
