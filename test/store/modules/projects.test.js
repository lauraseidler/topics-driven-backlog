// spy on console warnings
jest.spyOn(console, 'info').mockImplementation(text => text);

import projectsModule from '@/store/modules/projects';
import { mockResponse } from '../../util';

describe('The projects module', () => {
    it('returns a correct new template', () => {
        const template = projectsModule.getters.template()();
        expect(template.title).toBe('');
    });

    it('sends enroll request and commits the result', async () => {
        const mock = mockResponse('/projects/1/enrollments', 'POST');
        const commit = jest.fn();

        await projectsModule.actions.enroll({ commit }, 1);

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalled();
    });

    it('sends disenroll request and fetches the project', async () => {
        const mock = mockResponse('/projects/1/enrollment', 'DELETE');
        const dispatch = jest.fn();        

        await projectsModule.actions.disenroll({ dispatch }, { projectId: 1, courseId: 1 });

        expect(mock.correctRequest).toBe(true);
        expect(dispatch).toHaveBeenCalled();
    });
});