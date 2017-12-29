import NotFound from '@/components/elements/NotFound';
import { mount } from 'vue-test-utils';

describe('NotFound.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount(NotFound);
    });

    it('is a section with the class not-found', () => {
        expect(cmp.is('section.not-found')).toBe(true);
    });

    it('has a link to go back', () => {
        const link = cmp.find('a');
        expect(link.exists()).toBe(true);
        expect(link.text()).toBe('Go back');
    });

    it('has a link to go to the homepage', () => {
        const routerLink = cmp.find('router-link');
        expect(routerLink.exists()).toBe(true);
        expect(routerLink.element.getAttribute('to')).toBe('/');
        expect(routerLink.text()).toBe('Go to homepage');
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });
});
