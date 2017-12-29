import { shallow } from 'vue-test-utils';
import mockRouter from 'mock-vue-router';
import RouterBack from '@/components/elements/RouterBack';

const { $router, $route } = mockRouter(['/test', '/test2'], '/test');

describe('RouterBack.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = shallow(RouterBack, {
            mocks: {
                $router,
                $route,
            },
        });
    });

    it('is a link by default', () => {
        expect(cmp.is('a')).toBe(true);
        expect(cmp.element).toMatchSnapshot();
    });

    it('goes back one step in the router when clicked', () => {
        cmp.vm.$router.push('/test2');
        cmp.trigger('click');
        expect(cmp.vm.$route.path).toBe('/test');
    });

    it('can also render a button', () => {
        cmp = shallow(RouterBack, {
            propsData: {
                tag: 'button',
            },
        });

        expect(cmp.is('button')).toBe(true);
    });
});
