import Vue from 'vue';
import App from '../../frontend/components/App';
import {shallow} from 'vue-test-utils';

describe('App.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = shallow(App);
    });

    it('is a div with id app', () => {
        expect(cmp.is('#app')).toBe(true);
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});