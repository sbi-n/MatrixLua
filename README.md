# 이 라이브러리는 더 이상 관리 되지 않습니다
모듈의 목적이 Matrix(행렬) 보단 Tensor에 가깝고, 저장소의 이름이 혼란을 야기할수 있으므로\
TensorLua저장소를 통해 사용해주시길 부탁드립니다



# 소개
파이썬의 Numpy 패키지에 많은 참고를 하고 있으며\
수학에서 쓰이는 행렬의 개념을 luau에서 사용하기 위한 모듈입니다\
Numpy 패키지의 계산을 모방했기 때문에 선형대수에서 정의되지 않은 스칼라 덧셈을 지원합니다

# 예문
```lua
local Matrix = require("path/to/module")
local Types = Matrix.Types
    
local Value = Matrix.new(
    Types.UInt8,
    Matrix.vector(4, 4, 4, 4)
):fill(32)

print(Value:get(Matrix.vector(0, 0, 0, 0))) --> 32

Value:set(Matrix.vector(0, 0, 0, 0), 48)
print(Value:get(Matrix.vector(0, 0, 0, 0))) --> 48
```

# 개체의 크기
만약 Matrix.Vector(2,2)의 행렬 = 2x2

# 개체의 위치
위치 벡터는 (0,0)부터 시작하기 때문에, 따라서 Matix.Vector(1,1)의 위치는 n5를 나타내고 있습니다.
|   | 0  | 1  |  2  |  3  |
|---|----|----|-----|-----|
| 0 | n0 | n1 | n2  | n3  |
| 1 | n3 | n5 | n6  | n7  |
| 2 | n8 | n9 | n10 | n11 |

# 주의
아직 이 프로젝트는 미완성이므로 아직 프로덕션에 사용하지 마세요\
행렬 데이터는 직렬화되어 buffer에 저장되므로, buffer의 최대 수용량인 2^30바이트(1GB)를 초과할수 없습니다.
