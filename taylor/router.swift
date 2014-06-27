//
//  router.swift
//  TaylorTest
//
//  Created by Jorge Izquierdo on 19/06/14.
//  Copyright (c) 2014 Jorge Izquierdo. All rights reserved.
//

import Foundation

class Router {
    
    var _routes: Route[] = Route[]()
    
    func addRoute(route: Route) -> Bool {
        
        self._routes += route
        return true
    }
    
    func handler() -> TaylorHandler {
        
        return {
            
            request, response in
            
            var t: TaylorHandlerTuple = (request: request, response: response)
            
            if let route = self.detectRouteForRequest(t.request){
                
                //Execute all handlers
                for handler in route.handlers {
                    
                    if let tuple = handler(request: t.request, response: t.response) {
                        // Continue
                        t = tuple
                    }
                }
            }
            
            return t
        }
    }
    
    func detectRouteForRequest(request: Request) -> Route? {
        
        for route in self._routes {
            
            request.parameters = Dictionary<String, String>()
            let compCount = route.pathComponents.count
            if route.method == request.method && compCount == request.pathComponents.count {
                
                for i in 0..compCount {
                    
                    var isParameter = route.pathComponents[i].isParameter
                    if !(isParameter || route.pathComponents[i].value == request.pathComponents[i]) {
                        
                        break
                    }
                    
                    if isParameter {
                        
                        request.parameters[route.pathComponents[i].value] = request.pathComponents[i]
                    }

                    if i == compCount - 1 {
                        return route
                    }
                }
            }
        }
        
        return nil
    }
    
    func 😕(request: Request, response: Response) -> Bool {
        
        response.sendError(404)
        return true
    }
}

