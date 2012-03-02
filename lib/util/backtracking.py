#
# Author: Filippo Squillace <sqoox85@gmail.com>
#
# Copyright 2010
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranties of
# MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

'''Python implementation of the backtracking algorithm.
'''
__author__ = 'Filippo Squillace'
__date__ = '29/09/2010'
__license__   = 'GPL v3'
__copyright__ = '2010'
__docformat__ = 'restructuredtext en'
__version__ = "1.0.3"



import inspect


class Problem:

    #----------------------------------------------------------------------
    def first_choice_point(self):
        """"""
        #print inspect.stack()[0][3] # Allows to know the name of the method
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def next_choice_point(self, ps):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def last_choice_point(self):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def first_choice(self, ps ):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def next_choice(self, s):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def last_choice(self, ps):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def assignable(self, scelta, puntoDiScelta):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def assign(self,  scelta, puntoDiScelta ):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def deassign(self, scelta, puntoDiScelta ):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def previous_choice_point (self, puntoDiScelta ):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def last_choice_assigned_to (self, puntoDiScelta ):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    #----------------------------------------------------------------------
    def get_solution(self):
        """"""
        raise NotImplementedError('Method has to be implemented by the concrete class')
    
    
    
    def __iter__(self):
        self.inizio_iter = True
        return self
    
    
    
    

    def next(self):
        """
        Template method
        """
        if self.inizio_iter:
            self.inizio_iter=False
            self.ps=self.first_choice_point()
            self.s=self.first_choice( self.ps );
            self.backtrack=False
            self.fine=False
        else:
            self.deassign( self.s, self.ps )
            if( self.s!=self.last_choice( self.ps ) ):
                self.s=self.next_choice( self.s )
            else:
                self.backtrack=True
            
        while(not self.fine):
            #forward
            while(  not self.backtrack ):
                if( self.assignable( self.s, self.ps ) ):
                    self.assign( self.s, self.ps )
                    if( self.ps==self.last_choice_point()):
                        return self.get_solution()
                    else:
                        self.ps=self.next_choice_point( self.ps )
                        self.s=self.first_choice( self.ps )
                elif( self.s!=self.last_choice( self.ps )):
                    self.s=self.next_choice( self.s )
                else:
                    self.backtrack=True
            #end while( !self.backtrack )
            #backward
            self.fine=(self.ps==self.first_choice_point())
            while( self.backtrack and not self.fine ):
                self.ps=self.previous_choice_point( self.ps )
                self.s=self.last_choice_assigned_to( self.ps )
                self.deassign( self.s, self.ps )
                if( not self.s==self.last_choice( self.ps ) ):
                    self.s=self.next_choice( self.s )
                    self.backtrack=False;
                elif( self.ps==self.first_choice_point() ):
                    self.fine=True
        
        raise StopIteration



########################################################################
class Mappa(Problem):
    """"""
    GIALLO=0
    ROSSO=1
    VERDE=2
    NERO=3
    n=0
    confinanti = [] # array di set
    stessoColore = [] # array di set
    soluzioni = 0



    #----------------------------------------------------------------------
    def __init__(self,  confinanti ):
        """Constructor"""
        self.confinanti = confinanti
        self.n=len(confinanti)
        self.stessoColore= [set(), set(), set(), set()];
    
    #----------------------------------------------------------------------
    def get_solution(self):
        """"""
        return self.stessoColore
        
    #----------------------------------------------------------------------
    def __str__(self):
        """"""
        pr = ''
        self.soluzioni+=1
        pr += "Soluzione nr "+str(self.soluzioni)+'\n'
        for nazione in range(self.n):
            for colore in range(self.GIALLO, self.NERO+1):
                if self.stessoColore[colore].issuperset(set([nazione])) :
                    pr += "Nazione ="+str(nazione)+" colore="
                    if colore==self.GIALLO:
                        pr += 'giallo\n'
                    elif colore==self.NERO:
                        pr += 'nero\n'
                    elif colore == self.ROSSO:
                        pr += 'rosso\n'
                    elif colore == self.VERDE:
                        pr += 'verde\n'
        pr += '\n'
        return pr

    #----------------------------------------------------------------------
    def first_choice_point(self):
        """"""
        return 0
            
    #----------------------------------------------------------------------
    def next_choice_point(self, nazione):
        """"""
        return nazione+1
    #----------------------------------------------------------------------
    def last_choice_point(self):
        """"""
        return self.n-1
    #----------------------------------------------------------------------
    def first_choice(self, nazione):
        """"""
        return self.GIALLO
    #----------------------------------------------------------------------
    def next_choice(self, colore):
        """"""
        return colore+1
    #----------------------------------------------------------------------
    def last_choice(self, nazione):
        """"""
        return self.NERO
    #----------------------------------------------------------------------
    def assignable(self, colore, nazione):
        """
        E' assegnabile colore a nazione se e' vuota l'intersezione tra
        confinanti di nazione e stessocolore di colore
        """
        return self.confinanti[nazione].isdisjoint(self.stessoColore[colore])
        
    #----------------------------------------------------------------------
    def assign(self, colore, nazione):
        """"""
        self.stessoColore[colore].add( nazione )
    #----------------------------------------------------------------------
    def deassign(self, colore, nazione):
        """"""
        self.stessoColore[colore].remove( nazione );
        
    #----------------------------------------------------------------------
    def previous_choice_point(self, nazione):
        """"""
        return nazione-1
        
    #----------------------------------------------------------------------
    def last_choice_assigned_to(self, nazione):
        """"""
        for colore in range(self.GIALLO,self.NERO+1):
            if( self.stessoColore[colore].issuperset(set([nazione])) ):
                return colore


            
def backtracking(choice_points, choices, assignable):
    """
    Template method
    choice_points: is a list of the choice points. Each of them will be assigned to a single choice for
          each solution.
    choices: is a list of choices.
    assignable: is a function that say when a choice is assignable to a choice points. 
          It needs three arguments:
               def assignable(choice, choice_points, solutions):
          In particular, solutions store the assignments of the previous choice points.
          It seems like that {cp0:c0, cp1:c1, ...} where cpI is a choice point and cI is a choice.
    """
    
    N = len(choices)
    M = len(choice_points)
    
    # solutions is the dict that has for each choice point (key) a choice (value)
    solutions = {}
    
    cp=0
    c=0
    backtrack=False
    end=False
        
    while(not end):
        #forward
        while(  not backtrack ):
            if( assignable( cp, c, solutions ) ):
                solutions[cp] = c
                if( cp==M-1):
                    yield {choice_points[k]:choices[v] for k,v in solutions.iteritems()}
                    del solutions[cp]
                    if not c==N-1:
                        c+=1
                    else:
                        backtrack = True
                else:
                    cp+=1
                    c=0
            elif( c!=N-1):
                c+=1
            else:
                backtrack=True

        #backward
        end=(cp==0)
        while( backtrack and not end ):
            cp-=1
            c=solutions.pop(cp)
            if( not c==N-1 ):
                c+=1
                backtrack=False;
            elif( cp==0 ):
                end=True
                
            
            
if __name__=='__main__':
    
    
    ############## 4 Colors Problem #############
    neighbors = [set(), set(),set(),set(),set()]
    neighbors[0].add(1)
    neighbors[0].add(2)
    neighbors[1].add(2)
    neighbors[1].add(3)
    neighbors[1].add(0)
    neighbors[2].add(0)
    neighbors[2].add(1)
    neighbors[2].add(4)
    neighbors[3].add(1)
    neighbors[3].add(4)
    neighbors[4].add(2)
    neighbors[4].add(3)


    nations = ['Italy','Spain','France','Germany','England']
    colors = ['Yellow','Red','Blue','Black']
    
    def assignable4Colors(nation, color, solutions):
        """
        It's assignable a color to a nation if it's empty the intersection between neighbors of nation
        and the nations of the same color in solutions.
        """
        sameColor = set([n for n,c in solutions.iteritems() if c==color ])
        return neighbors[nation].isdisjoint(sameColor)
    
    
    for s in backtracking(nations, colors, assignable4Colors):
        print s
        
        
    ############## 8 Queens Problem ###############    
    rows = ['1', '2', '3', '4', '5', '6', '7', '8']
    columns = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
    
    def assignable8Queens(row, column, solutions):
        for r, c in solutions.iteritems():
            if c == column:
                return False
            elif r-c == row-column:
                return False
            elif r+c == row+column:
                return False
        return True 
    
    for s in backtracking(rows, columns, assignable8Queens):
        print s
    
    ############# SUDOKU ####################
    positions = [(x, y) for x in range(9) for y in range(9)]
    figures = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
    
    def assignableSudoku(pos, figure, solutions):
        for p, f in solutions.iteritems():
            (x,y) = positions[p]
            (x2, y2) = positions[pos]
            if (x==x2 or y==y2) and figure==f:
                return False
            
        return True
    
    print backtracking(positions, figures, assignableSudoku).next()
    