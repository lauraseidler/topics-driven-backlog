// turn off vue console info
console.info = jest.fn();

import { state, actions } from '@/store';

describe('index.test.js', () => {
    it('initialises the store and submodules correctly', () => {
        const dispatch = jest.fn();

        actions.init({ state, dispatch });

        expect(state.initialised).toBe(true);
        expect(dispatch).toHaveBeenCalledWith('stories/init');
        expect(dispatch).toHaveBeenCalledWith('courses/init');
    });
});
