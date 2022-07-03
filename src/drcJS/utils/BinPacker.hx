package drcJS.utils;

enum GuillotineFreeRectChoiceHeuristic {
	BestAreaFit;
	BestShortSideFit;
	BestLongSideFit;
	WorstAreaFit;
	WorstShortSideFit;
	WorstLongSideFit;
}

enum GuillotineSplitHeuristic {
	ShorterLeftoverAxis;
	LongerLeftoverAxis;
	MinimizeArea;
	MaximizeArea;
	ShorterAxis;
	LongerAxis;
}

class BinPacker {

    public var binWidth(default, null):Int;

    public var binHeight(default, null):Int;
    
    public var usedRectangles(default, null):Array<Rect> = new Array<Rect>();
    
	public var freeRectangles(default, null):Array<Rect> = new Array<Rect>();

	// ** Privates.

	private var __rotation:Bool;

    public function new(width:Int = 0, height:Int = 0, rotation:Bool = true) {

        binWidth = width;

		binHeight = height;
		
		__rotation = rotation;

        var n = new Rect(0, 0, width, height);
        
		freeRectangles.push(n);
    }

    public function insert(width:Int, height:Int, merge:Bool, rectChoice:GuillotineFreeRectChoiceHeuristic, splitMethod:GuillotineSplitHeuristic):Rect {

        var data = findPositionForNewNode(width, height, rectChoice);

        var newRect = data.rect;
        
        var freeNodeIndex = data.nodeIndex;
        
        if (newRect == null || (newRect.width == 0 && newRect.height == 0) || freeNodeIndex < 0) {

			return null;
        }
        
        splitFreeRectByHeuristic(freeRectangles[freeNodeIndex], newRect, splitMethod);

        freeRectangles.splice(freeNodeIndex, 1);

        if (merge) {

			mergeFreeList();
		}

        usedRectangles.push(newRect);

        return newRect;
    }

    public function occupancy():Float {
		var usedSurfaceArea:Float = 0;
		for (i in 0...usedRectangles.length) {
			usedSurfaceArea += usedRectangles[i].width * usedRectangles[i].height;
		}
		
		return usedSurfaceArea / (binWidth * binHeight);
	}

    public function mergeFreeList():Void {

		for (i in 0...freeRectangles.length) {
			var j = i + 1;
			while (j < freeRectangles.length) {
				if (freeRectangles[i].width == freeRectangles[j].width && freeRectangles[i].x == freeRectangles[j].height) {
					if (freeRectangles[i].y == freeRectangles[j].y + freeRectangles[j].height) {
						freeRectangles[i].y -= freeRectangles[j].height;
						freeRectangles[i].height += freeRectangles[j].height;
						freeRectangles.splice(j, 1);
					} else if (freeRectangles[i].y + freeRectangles[i].height == freeRectangles[j].y) {
						freeRectangles[i].height += freeRectangles[j].height;
						freeRectangles.splice(j, 1);
					} else {
						j++;
					}
				} else if (freeRectangles[i].height == freeRectangles[j].height && freeRectangles[i].y == freeRectangles[j].y) {
					if (freeRectangles[i].x == freeRectangles[j].x + freeRectangles[j].width) {
						freeRectangles[i].x -= freeRectangles[j].width;
						freeRectangles[i].width += freeRectangles[j].width;
						freeRectangles.splice(j, 1);
					} else if (freeRectangles[i].x + freeRectangles[i].width == freeRectangles[j].x) {
						freeRectangles[i].width += freeRectangles[j].width;
						freeRectangles.splice(j, 1);
					} else {
						j++;
					}
				} else {
					j++;
				}
			}
		}	
    }

    private function splitFreeRectByHeuristic(freeRect:Rect, placedRect:Rect, method:GuillotineSplitHeuristic):Void {

        var w = freeRect.width - placedRect.width;
        
		var h = freeRect.height - placedRect.height;
		
		var splitHorizontal:Bool;
		switch(method) {
			case GuillotineSplitHeuristic.ShorterLeftoverAxis:
				splitHorizontal = (w <= h);
			case GuillotineSplitHeuristic.LongerLeftoverAxis:
				splitHorizontal = (w > h);
			case GuillotineSplitHeuristic.MinimizeArea:
				splitHorizontal = (placedRect.width * h > w * placedRect.height);
			case GuillotineSplitHeuristic.MaximizeArea:
				splitHorizontal = (placedRect.width * h <= w * placedRect.height);
			case GuillotineSplitHeuristic.ShorterAxis:
				splitHorizontal = (freeRect.width <= freeRect.height);
			case GuillotineSplitHeuristic.LongerAxis:
				splitHorizontal = (freeRect.width > freeRect.height);
			default:
				splitHorizontal = true;
				
		}
		
		splitFreeRectAlongAxis(freeRect, placedRect, splitHorizontal);
    }
    
    private function splitFreeRectAlongAxis(freeRect:Rect, placedRect:Rect, splitHorizontal:Bool):Void {
		var bottom = new Rect(freeRect.x, freeRect.y + placedRect.height, 0, freeRect.height - placedRect.height);
		var right = new Rect(freeRect.x + placedRect.width, freeRect.y, freeRect.width - placedRect.width, 0);
		
		if (splitHorizontal) {
			bottom.width = freeRect.width;
			right.height = placedRect.height;
		} else {
			bottom.width = placedRect.width;
			right.height = freeRect.height;
		}
		
		if (bottom.width > 0 && bottom.height > 0) {
			freeRectangles.push(bottom);
		}
		if (right.width > 0 && right.height > 0) {
			freeRectangles.push(right);
		}
	}

    private function findPositionForNewNode(width:Int, height:Int, rectChoice:GuillotineFreeRectChoiceHeuristic): { rect:Rect, nodeIndex:Int } {

        var bestNode = new Rect();

        var nodeIndex:Int = 0;
        
        var bestScore = 0x3FFFFFFF; // Neko max int is this (2^30, 0x3FFFFFFF)
        
        for (i in 0...freeRectangles.length) {

            if (width == freeRectangles[i].width && height == freeRectangles[i].height) {

                bestNode.x = freeRectangles[i].x;

                bestNode.y = freeRectangles[i].y;
                
                bestNode.width = width;
                
                bestNode.height = height;
                
                bestScore = 0xC0000000; // Neko min int is this (2^30-1, 0xC0000000)
                
				nodeIndex = i;

                break;
            }
            else if (height == freeRectangles[i].width && width == freeRectangles[i].height && __rotation) {

                bestNode.x = freeRectangles[i].x;

                bestNode.y = freeRectangles[i].y;
                
                bestNode.width = height;
                
                bestNode.height = width;
                
                bestNode.flipped = true;
                
                bestScore =  0xC0000000; // Neko min int is this (2^30-1, 0xC0000000)
                
                nodeIndex = i;

                break;
            }
            else if (width <= freeRectangles[i].width && height <= freeRectangles[i].height) {

                var score = scoreByHeuristic(width, height, freeRectangles[i], rectChoice);

                if (score < bestScore) {

                    bestNode.x = freeRectangles[i].x;
                    
                    bestNode.y = freeRectangles[i].y;
                    
                    bestNode.width = width;
                    
                    bestNode.height = height;
                    
                    bestScore = score;
                    
					nodeIndex = i;
				}
            }
            else if (height <= freeRectangles[i].width && width <= freeRectangles[i].height && __rotation) {

                var score = scoreByHeuristic(height, width, freeRectangles[i], rectChoice);

                bestNode.x = freeRectangles[i].x;

                bestNode.y = freeRectangles[i].y;

                bestNode.width = height;

                bestNode.height = width;

                bestNode.flipped = true;

                bestScore = score;

                nodeIndex = i;
            }
        }

        if (bestNode.width == 0 && bestNode.height == 0) {

			return { rect: null, nodeIndex: -1 };
		}

        return { rect: bestNode, nodeIndex: nodeIndex };
    }

    private static function scoreByHeuristic(width:Int, height:Int, freeRect:Rect, rectChoice:GuillotineFreeRectChoiceHeuristic):Int {
		return switch(rectChoice) {
			case GuillotineFreeRectChoiceHeuristic.BestAreaFit:
				return scoreBestAreaFit(width, height, freeRect);
			case GuillotineFreeRectChoiceHeuristic.BestShortSideFit:
				scoreBestShortSideFit(width, height, freeRect);
			case GuillotineFreeRectChoiceHeuristic.BestLongSideFit:
				scoreBestLongSideFit(width, height, freeRect);
			case GuillotineFreeRectChoiceHeuristic.WorstAreaFit:
				scoreWorstAreaFit(width, height, freeRect);
			case GuillotineFreeRectChoiceHeuristic.WorstShortSideFit:
				scoreWorstShortSideFit(width, height, freeRect);
			case GuillotineFreeRectChoiceHeuristic.WorstLongSideFit:
				scoreWorstLongSideFit(width, height, freeRect);
		}
    }
    
    private static function scoreBestAreaFit(width:Int, height:Int, freeRect:Rect):Int {
		return Std.int(freeRect.width * freeRect.height - width * height);
	}
	
	private static function scoreBestShortSideFit(width:Int, height:Int, freeRect:Rect):Int {
		var leftoverHoriz = Math.abs(freeRect.width - width);
		var leftoverVert = Math.abs(freeRect.height - height);
		var leftover = Math.min(leftoverHoriz, leftoverVert);
		return Std.int(leftover);
	}
	
	private static function scoreBestLongSideFit(width:Int, height:Int, freeRect:Rect):Int {
		var leftoverHoriz = Math.abs(freeRect.width - width);
		var leftoverVert = Math.abs(freeRect.height - height);
		var leftover = Math.max(leftoverHoriz, leftoverVert);
		return Std.int(leftover);
	}
	
	private static function scoreWorstAreaFit(width:Int, height:Int, freeRect:Rect):Int {
		return -scoreBestAreaFit(width, height, freeRect);
	}
	
	private static function scoreWorstShortSideFit(width:Int, height:Int, freeRect:Rect):Int {
		return -scoreBestShortSideFit(width, height, freeRect);
	}
	
	private static function scoreWorstLongSideFit(width:Int, height:Int, freeRect:Rect):Int {
		return -scoreBestLongSideFit(width, height, freeRect);
	}
}

class Rect {

	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public var flipped:Bool; // If a rect is flipped, then width and height are swapped and this is marked true
	
	public inline function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0, flipped:Bool = false) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.flipped = flipped;
	}
	
	public inline function clone():Rect {
		return new Rect(x, y, width, height);
	}
	
	public inline function isContainedIn(other:Rect):Bool {
		return x >= other.x && y >= other.y	&& x + width <= other.x + other.width && y + height <= other.y + other.height;
	}
}