import { mount, createLocalVue } from 'vue-test-utils';
import Vuex from 'vuex';
import Vuelidate from 'vuelidate';
import CoursesPage from '@/components/pages/CoursesPage';
import { getters as courseGetters } from '@/store/courses';

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuelidate);

describe('CoursesPage.test.js', () => {
    let cmp, store, actions, getters;

    beforeEach(() => {
        actions = {
            save: jest.fn(),
        };

        getters = {
            all: () => [
                {
                    title: 'Test course',
                    semester_type: 'W',
                    semester_year: 2017,
                },
            ],
            new: courseGetters.new,
        };

        store = new Vuex.Store({
            modules: {
                courses: {
                    namespaced: true,
                    actions,
                    getters,
                },
            },
        });

        cmp = mount(CoursesPage, {
            localVue,
            store,
        });
    });

    it('does not add a course when invalid', () => {
        cmp.vm.saveCourse();

        expect(actions.save).not.toBeCalled();
    });

    it('adds a course when data valid', () => {
        cmp.vm.newCourse = {
            title: 'Test course',
            semester: 'W*2017',
        };

        cmp.vm.saveCourse();

        expect(actions.save).toBeCalled();
    });

    it('has the expected html structure', () => {
        expect(cmp.element).toMatchSnapshot();
    });

    it('has the expected html structure when form visible', () => {
        cmp.vm.showForm = true;
        cmp.update();
        expect(cmp.element).toMatchSnapshot();
    });
});
