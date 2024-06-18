import {defineStore} from 'pinia'


function hasPermission(route, role) {
    const routeRole = route.meta?.role ? route.meta.role : []
    if (!role.length || !routeRole.length) {
        return false
    }
    return role.some((item) => routeRole.includes(item))
}

function filterAsyncRoutes(routes = [], role) {
    const ret = []
    routes.forEach((route) => {
        if (hasPermission(route, role)) {
            const curRoute = {
                ...route,
                children: [],
            }
            if (route.children && route.children.length) {
                curRoute.children = filterAsyncRoutes(route.children, role)
            } else {
                Reflect.deleteProperty(curRoute, 'children')
            }
            ret.push(curRoute)
        }
    })
    return ret
}


export const usePermissionStore = defineStore('permission', {
    state: () => {
        return {
            accessRoutes: []
        }
    },
    getters: {
        getRoutes() {
            return basicRoutes.concat(this.accessRoutes)
        },
        getMenus() {
            return this.routes.filter((route) => route.name && !route.meta.hidden)
        },
    },
    actions: {
        // generateRoutes(role = []) {
        //     const accessRoutes = filterAsyncRoutes(asyncRoutes, role)
        //     this.accessRoutes = accessRoutes
        //     return accessRoutes
        // },
    }
})
